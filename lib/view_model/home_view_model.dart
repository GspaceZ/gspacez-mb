import 'package:flutter/widgets.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/model/comment_response.dart';
import 'package:untitled/model/post_model_response.dart';
import 'package:untitled/service/event_bus_service.dart';
import 'package:untitled/service/post_service.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    scrollController.addListener(_onScroll);
    fetchPost();
    _init();
  }

  final List<PostModelResponse> posts = [];
  int _pageNum = 0;
  final int _pageSize = 20;
  bool _isLoading = false;
  bool _hasMore = true;
  String urlAvatar = AppConstants.urlImageDefault;
  final ScrollController scrollController = ScrollController();

  Future<void> fetchPost({bool isRefresh = false}) async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      if (isRefresh) {
        _pageNum = 0;
        posts.clear();
        _hasMore = true;
      }

      final response =
          await PostService.instance.getNewFeed(_pageNum, _pageSize);

      if (response.content.isNotEmpty) {
        posts.addAll(response.content);
        _pageNum++;
      }

      if (_pageNum >= response.totalPages) {
        _hasMore = false;
      }
    } catch (e) {
      throw Exception("Failed to fetch posts: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      fetchPost();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  bool get isLoading => _isLoading;

  bool get hasMore => _hasMore;

  _init() async {
    urlAvatar = await LocalStorage.instance.userUrlAvatar ??
        AppConstants.urlImageDefault;
    notifyListeners();
    KeyedEventBus()
        .listener<PostModelResponse>(AppConstants.keyCreatePost)
        .listen((data) {
      posts.insert(0, data);
      notifyListeners();
    });
  }

  Future<List<CommentResponse>> getComment(PostModelResponse post) async {
    final response = await PostService.instance.getCommentById(post.id);
    return response;
  }
}
