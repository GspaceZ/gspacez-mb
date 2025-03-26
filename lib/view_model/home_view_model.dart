import 'package:flutter/widgets.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/model/comment_response.dart';
import 'package:untitled/model/post_model_response.dart';
import 'package:untitled/service/post_service.dart';
import '../model/post_model_request.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    fetchPost();
    _init();
  }

  final List<PostModelResponse> posts = [];
  String urlAvatar = AppConstants.urlImageDefault;
  Future<void> fetchPost() async {
    final response = await PostService.instance.getNewFeed();
    posts.clear();

    /// TODO: FIX API CALL
    posts.addAll(response);
    notifyListeners();
  }

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
