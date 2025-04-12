import 'dart:convert';

import 'package:untitled/model/base_response_api.dart';
import 'package:untitled/model/comment_response.dart';
import 'package:untitled/model/post_model_response.dart';
import 'package:untitled/service/config_api/config_api.dart';
import '../model/post_model_request.dart';

class PostService {
  //private constructor
  PostService._privateConstructor();

  //static instance
  static final PostService _instance = PostService._privateConstructor();

  //static getter for the instance
  static PostService get instance => _instance;

  Future<List<PostModelResponse>> getNewFeed(int pageNum, int pageSize) async {
    final response = await callApi(
      "post-service/posts/newsfeed?pageNum=$pageNum&pageSize=$pageSize",
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
      final List<PostModelResponse> posts = baseResponse.result
          .map((post) => PostModelResponse.fromJson(post))
          .toList()
          .cast<PostModelResponse>();
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

  Future<PostModelResponse> createPost(PostModelRequest postModelRequest) async {
    final response = await callApi(
      "post-service/posts/create",
      "POST",
      isToken: true,
      data: postModelRequest.toJson(),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap =
      jsonDecode(utf8.decode(response.bodyBytes));
      final BaseResponseApi baseResponse = BaseResponseApi.fromJson(responseMap);

      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }

        return PostModelResponse.fromJson(baseResponse.result);
    } else {
      throw Exception('Failed to create post');
    }
  }

  Future<BaseResponseApi> setPrivacyPost(String postId, String privacy) async {
    final response = await callApi(
      "post-service/posts/$postId/update-privacy",
      'PUT',
      isToken: true,
      data: {"privacy": privacy}
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap = jsonDecode(utf8.decode(response.bodyBytes));
      final BaseResponseApi baseResponse = BaseResponseApi.fromJson(responseMap);
      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }
      return baseResponse;
    } else {
      throw Exception('Failed to set privacy for post');
    }
  }

  Future<List<PostModelResponse>> getHistoryPosts(int size, int page) async {
    final response = await callApi(
      "post-service/posts/history?size=$size&page=$page",
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
      final List<PostModelResponse> posts = baseResponse.result['content']
          .map((post) => PostModelResponse.fromJson(post))
          .toList()
          .cast<PostModelResponse>();
      return posts;
    } else {
      throw Exception('Failed to get history posts');
    }
  }
}
