import 'package:flutter/widgets.dart';
import 'package:untitled/model/content_post_model.dart';
import 'package:untitled/model/create_post_request.dart';
import 'package:untitled/model/post_model_response.dart';
import 'package:untitled/service/post_service.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    fetchPost();
  }

  final List<PostModel> posts = [];

  Future<void> fetchPost() async {
    final response = await PostService.instance.getNewFeed();
    posts.addAll(response);
    notifyListeners();
  }

  Future<void> createPost(CreatePostRequest post) async {
    final response = await PostService.instance.createPost(post);
    // create post from api

    // posts.insert(0, postModel);
    notifyListeners();
  }
}
