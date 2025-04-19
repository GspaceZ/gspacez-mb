import 'package:flutter/widgets.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/model/post_model_response.dart';
import 'package:untitled/service/post_service.dart';

class HistoryViewModel extends ChangeNotifier {
  HistoryViewModel() {
    scrollController.addListener(_onScroll);
    fetchHistoryPosts();
    _init();
  }

  final List<PostModelResponse> posts = [];
  int _page = 0;
  final int _size = 20;
  bool _isLoading = false;
  bool _hasMore = true;
  String urlAvatar = AppConstants.urlImageDefault;
  final ScrollController scrollController = ScrollController();

  Future<void> fetchHistoryPosts({bool isRefresh = false}) async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      if (isRefresh) {
        _page = 1;
        posts.clear();
        _hasMore = true;
      }

      final response = await PostService.instance.getHistoryPosts(_size, _page);

      if (response.isNotEmpty) {
        posts.addAll(response);
        _page++;
      }

      if (response.length < _size) {
        _hasMore = false;
      }
    } catch (e) {
      throw Exception("Failed to fetch history posts: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      fetchHistoryPosts();
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
  }

  // Future<List<CommentResponse>> getComment(PostModelResponse post) async {
  //   final response = await PostService.instance.getCommentById(post.id);
  //   return response;
  // }
}
