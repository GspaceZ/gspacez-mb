import 'dart:convert';

import 'package:untitled/model/base_response_api.dart';
import 'package:untitled/model/comment_response.dart';
import 'package:untitled/model/post_model_response.dart';
import 'package:untitled/service/config_api/config_api.dart';

class PostService {
  //private constructor
  PostService._privateConstructor();

  //static instance
  static final PostService _instance = PostService._privateConstructor();

  //static getter for the instance
  static PostService get instance => _instance;

  Future<List<PostModel>> getNewFeed() async {
    final response = await callApi(
      "post-service/posts/newsfeed?pageNum=1&pageSize=20",
      'GET',
      isToken: true,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap =
          jsonDecode(utf8.decode(response.bodyBytes));
      final BaseResponseApi baseResponse =
          BaseResponseApi.fromJson(responseMap);
      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }
      final List<PostModel> posts = baseResponse.result
          .map((post) => PostModel.fromJson(post))
          .toList()
          .cast<PostModel>();
      return posts;
    } else {
      throw Exception('Failed to get new feed');
    }
  }

  Future<List<CommentResponse>> getCommentById(String postId) async {
    final response = await callApi(
      "post-service/posts/$postId/comment",
      'GET',
      isToken: true,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap =
          jsonDecode(utf8.decode(response.bodyBytes));
      final BaseResponseApi baseResponse =
          BaseResponseApi.fromJson(responseMap);
      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }
      final List<CommentResponse> comments = baseResponse.result
          .map((comment) => CommentResponse.fromJson(comment))
          .toList()
          .cast<CommentResponse>();
      return comments;
    } else {
      throw Exception('Failed to get comments');
    }
  }
}
