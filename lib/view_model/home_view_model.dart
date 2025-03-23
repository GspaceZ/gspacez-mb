import 'package:flutter/widgets.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/model/comment_response.dart';
import 'package:untitled/model/content_post_model.dart';
import 'package:untitled/model/post_model_response.dart';
import 'package:untitled/service/post_service.dart';

import '../model/create_post_response.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    fetchPost();
    _init();
  }

  final List<PostModel> posts = [];
  String urlAvatar = AppConstants.urlImageDefault;
  Future<void> fetchPost() async {
    final response = await PostService.instance.getNewFeed();
    posts.clear();
    posts.addAll(response);
    notifyListeners();
  }

  _init() async {
    urlAvatar = await LocalStorage.instance.userUrlAvatar ??
        AppConstants.urlImageDefault;
    notifyListeners();
  }

  Future<void> createPost(ContentPostModel contentPost) async {
    try {
      final CreatePostResponse newPost =
          await PostService.instance.createPost(contentPost);

      final postModel = PostModel(
        id: newPost.id,
        type: newPost.type,
        privacy: newPost.privacy,
        content: contentPost,
        profileId: newPost.profileId,
        profileName: await LocalStorage.instance.userName ?? '',
        avatarUrl: newPost.avatarUrl,
        hashTags: newPost.hashTags,
        trendingPoint: newPost.trendingPoint,
        createdAt: newPost.createdAt,
        updatedAt: newPost.updatedAt,
        hidden: false,
      );

      posts.insert(0, postModel);
      notifyListeners();
    } catch (e) {
      throw Exception("Failed to create post: $e");
    }
  }

  Future<List<CommentResponse>> getComment(PostModel post) async {
    final response = await PostService.instance.getCommentById(post.id);
    return response;
  }
}
