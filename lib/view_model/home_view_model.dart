import 'package:flutter/widgets.dart';
import 'package:untitled/components/dialog_loading.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/main.dart';
import 'package:untitled/model/comment_response.dart';
import 'package:untitled/model/post_model_response.dart';
import 'package:untitled/service/post_service.dart';
import '../model/post_model_request.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    scrollController.addListener(_onScroll);
    fetchPost();
    _init();
  }

  final List<PostModelResponse> posts = [];
  int _pageNum = 1;
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
        _pageNum = 1;
        posts.clear();
        _hasMore = true;
      }

      final response = await PostService.instance.getNewFeed(_pageNum, _pageSize);

      if (response.isNotEmpty) {
        posts.addAll(response);
        _pageNum++;
      }

      if (response.length < _pageSize) {
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
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
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
  }

  Future<void> createPost(PostModelRequest postModelRequest) async {
    try {
      final PostModelResponse newPost =
          await PostService.instance.createPost(postModelRequest);

      final postModel = PostModelResponse(
        id: newPost.id,
        profileId: newPost.profileId,
        profileName: await LocalStorage.instance.userName ?? '',
        avatarUrl: newPost.avatarUrl,
        content: newPost.content,
        comments: newPost.comments,
        type: newPost.type,
        privacy: newPost.privacy,
        hashTags: newPost.hashTags,
        createdAt: newPost.createdAt,
        updatedAt: newPost.updatedAt,
        title: newPost.title,
        totalLike: newPost.totalLike,
        totalDislike: newPost.totalDislike,
        liked: newPost.liked,
        disliked: newPost.disliked
      );

      posts.insert(0, postModel);
      notifyListeners();
    } catch (e) {
      throw Exception("Failed to create post: $e");
    }
  }

  Future<List<CommentResponse>> getComment(PostModelResponse post) async {
    final response = await PostService.instance.getCommentById(post.id);
    return response;
  }
}
