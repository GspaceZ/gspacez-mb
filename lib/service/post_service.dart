import 'dart:convert';

import 'package:untitled/extensions/log.dart';
import 'package:untitled/model/base_response_api.dart';
import 'package:untitled/model/comment_response.dart';
import 'package:untitled/model/discussion_form_request.dart';
import 'package:untitled/model/discussion_response.dart';
import 'package:untitled/model/explore_model.dart';
import 'package:untitled/model/post_model_response.dart';
import 'package:untitled/model/react_post_response.dart';
import 'package:untitled/service/config_api/config_api.dart';

import '../model/comment_request.dart';
import '../model/discussion_comment_response.dart';
import '../model/paging_result.dart';
import '../model/post_model_request.dart';

class PostService {
  //private constructor
  PostService._privateConstructor();

  //static instance
  static final PostService _instance = PostService._privateConstructor();

  //static getter for the instance
  static PostService get instance => _instance;

  Future<PagingResult> getNewFeed(int pageNum, int pageSize) async {
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
        Log.error(baseResponse.message);
        throw Exception(baseResponse.message);
      }
      final resultMap = baseResponse.result as Map<String, dynamic>;

      return PagingResult<PostModelResponse>.fromJson(
        resultMap,
        (json) => PostModelResponse.fromJson(json),
      );
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

  Future<PostModelResponse> createPost(
      PostModelRequest postModelRequest) async {
    final response = await callApi(
      "post-service/posts/create",
      "POST",
      isToken: true,
      data: postModelRequest.toJson(),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap =
          jsonDecode(utf8.decode(response.bodyBytes));
      final BaseResponseApi baseResponse =
          BaseResponseApi.fromJson(responseMap);

      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }

      return PostModelResponse.fromJson(baseResponse.result);
    } else {
      throw Exception('Failed to create post');
    }
  }

  Future<PostModelResponse> commentPost(
      CommentRequest commentRequest, String postId) async {
    final response = await callApi(
      "post-service/posts/comment/$postId",
      "POST",
      isToken: true,
      data: commentRequest.toJson(),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap =
          jsonDecode(utf8.decode(response.bodyBytes));
      final BaseResponseApi baseResponse =
          BaseResponseApi.fromJson(responseMap);

      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }

      return PostModelResponse.fromJson(baseResponse.result);
    } else {
      throw Exception('Failed to comment to post');
    }
  }

  Future<BaseResponseApi> setPrivacyPost(String postId, String privacy) async {
    final response = await callApi(
        "post-service/posts/$postId/update-privacy", 'PUT',
        isToken: true, data: {"privacy": privacy});

    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap =
          jsonDecode(utf8.decode(response.bodyBytes));
      final BaseResponseApi baseResponse =
          BaseResponseApi.fromJson(responseMap);
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

  Future<List<ExploreModel>> getArticles(int size, int page) async {
    final response = await callApi(
      "post-service/explore/articles?size=$size&page=$page",
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
      final List<ExploreModel> posts = baseResponse.result['content']
          .map((post) => ExploreModel.fromJson(post))
          .toList()
          .cast<ExploreModel>();
      return posts;
    } else {
      throw Exception('Failed to get explore posts');
    }
  }

  Future<ReactPostResponse> reactPost(String postId, String reactType) async {
    final response = await callApi(
      "post-service/posts/react/$postId",
      "PATCH",
      isToken: true,
      data: {
        "reactType": reactType,
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap =
          jsonDecode(utf8.decode(response.bodyBytes));
      final BaseResponseApi baseResponse =
          BaseResponseApi.fromJson(responseMap);

      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }

      return ReactPostResponse.fromJson(baseResponse.result);
    } else {
      throw Exception('Failed to create post');
    }
  }

  Future<List<PostModelResponse>> getSquadPosts(
      String tagName, int size, int page) async {
    final response = await callApi(
      "post-service/posts/squad/$tagName/accepted?size=$size&page=$page",
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
      throw Exception('Failed to get posts in squad');
    }
  }

  Future<List<String>> searchTags(String query) async {
    final response = await callApi(
      "post-service/tags/search?searchText=$query",
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
      final List<String> tags = List<String>.from(baseResponse.result);
      return tags;
    } else {
      throw Exception('Failed to search tags');
    }
  }

  Future<List<PostModelResponse>> getPostsByHashtag(
      String hashtag, int size, int page) async {
    final response = await callApi(
      "post-service/posts/posts-by-hashtag?hashTag=$hashtag&size=$size&page=$page",
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
      throw Exception('Failed to get posts by hashtag');
    }
  }

  Future<PostModelResponse> getPostDetailById(String postId) async {
    final response = await callApi(
      "post-service/posts/$postId",
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
      final post = PostModelResponse.fromJson(baseResponse.result);
      return post;
    } else {
      throw Exception('Failed to get posts by id');
    }
  }

  Future<List<PostModelResponse>> searchPost(
      String query, int size, int page) async {
    try {
      final response = await callApi(
        "post-service/posts/search?size=$size&page=$page&searchText=$query",
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
            .map((user) => PostModelResponse.fromJson(user))
            .toList()
            .cast<PostModelResponse>();
        return posts;
      } else {
        Log.debug(response.body);
        throw Exception('Failed to search Post');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<List<String>> getPopularsTags() async {
    final response = await callApi(
      "post-service/tags/populars",
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
      final List<String> popularsTags = List<String>.from(baseResponse.result);
      return popularsTags;
    } else {
      throw Exception('Failed to get populars tags');
    }
  }

  Future<List<DiscussionResponse>> searchDiscussions(String query, int size, int page) async {
    try {
      final response = await callApi(
        "post-service/discussions/search?searchText=$query&size=$size&page=$page",
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
        final List<DiscussionResponse> discussions = baseResponse.result['content']
            .map((item) => DiscussionResponse.fromJson(item))
            .toList()
            .cast<DiscussionResponse>();
        return discussions;
      } else {
        Log.debug(response.body);
        throw Exception('Failed to search discussions');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<DiscussionResponse> getDetailDiscussion(String id) async {
    try {
      final response = await callApi(
        "post-service/discussions/$id",
        'GET',
        isToken: true,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = jsonDecode(utf8.decode(response.bodyBytes));
        final BaseResponseApi baseResponse = BaseResponseApi.fromJson(responseMap);

        if (baseResponse.code != 1000) {
          throw Exception(baseResponse.message);
        }

        return DiscussionResponse.fromJson(baseResponse.result);
      } else {
        Log.debug(response.body);
        throw Exception('Failed to get detail discussion');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<DiscussionResponse> createDiscussion(DiscussionFormRequest request) async {
    final response = await callApi(
      "post-service/discussions/create",
      "POST",
      isToken: true,
      data: request.toJson(),
    );

    if (response.statusCode == 200) {
      final responseMap = jsonDecode(utf8.decode(response.bodyBytes));
      final baseResponse = BaseResponseApi.fromJson(responseMap);

      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }

      return DiscussionResponse.fromJson(baseResponse.result);
    } else {
      throw Exception('Failed to create discussion');
    }
  }

  Future<DiscussionResponse> updateDiscussion(DiscussionFormRequest request, String id) async {
    final response = await callApi(
      "post-service/discussions/$id/update",
      "PUT",
      isToken: true,
      data: request.toJson(),
    );

    if (response.statusCode == 200) {
      final responseMap = jsonDecode(utf8.decode(response.bodyBytes));
      final baseResponse = BaseResponseApi.fromJson(responseMap);

      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }

      return DiscussionResponse.fromJson(baseResponse.result);
    } else {
      throw Exception('Failed to update discussion');
    }
  }

  Future<DiscussionResponse> toggleDiscussion(String id, bool isOpen) async {
    final response = await callApi(
      "post-service/discussions/$id/status",
      "PATCH",
      isToken: true,
      data: {
        "isOpen": isOpen,
      },
    );

    if (response.statusCode == 200) {
      final responseMap = jsonDecode(utf8.decode(response.bodyBytes));
      final baseResponse = BaseResponseApi.fromJson(responseMap);

      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }

      return DiscussionResponse.fromJson(baseResponse.result);
    } else {
      throw Exception('Failed to toggle discussion');
    }
  }

  Future<VoteResponse> votePoll(String id, String optionId) async {
    final response = await callApi(
      "post-service/discussions/$id/vote",
      "POST",
      isToken: true,
      data: {
        "optionId": optionId,
      },
    );

    if (response.statusCode == 200) {
      final responseMap = jsonDecode(utf8.decode(response.bodyBytes));
      final baseResponse = BaseResponseApi.fromJson(responseMap);

      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }

      return VoteResponse.fromJson(baseResponse.result as Map<String, dynamic>);
    } else {
      throw Exception('Failed to vote in discussion');
    }
  }

  Future<DiscussionCommentResponse> getCommentDiscussion(String id, int page, int size) async {
    try {
      final response = await callApi(
        "post-service/discussions/$id/comments?page=$page&size=$size",
        'GET',
        isToken: true,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = jsonDecode(utf8.decode(response.bodyBytes));
        final BaseResponseApi baseResponse = BaseResponseApi.fromJson(responseMap);

        if (baseResponse.code != 1000) {
          throw Exception(baseResponse.message);
        }

        return DiscussionCommentResponse.fromJson(baseResponse.result);
      } else {
        Log.debug(response.body);
        throw Exception('Failed to get comment of discussion');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<DiscussionCommentContent> postComment(String discussionId, String content) async {
    try {
      final response = await callApi(
        "post-service/discussions/$discussionId/comments/create",
        'POST',
        data: {
          "commentContent": content,
        },
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseMap = jsonDecode(utf8.decode(response.bodyBytes));
        final BaseResponseApi baseResponse = BaseResponseApi.fromJson(responseMap);

        if (baseResponse.code != 1000) {
          throw Exception(baseResponse.message);
        }

        return DiscussionCommentContent.fromJson(baseResponse.result);
      } else {
        Log.debug(response.body);
        throw Exception('Failed to post comment');
      }
    } catch (error) {
      Log.debug('Error posting comment: $error');
      rethrow;
    }
  }

  Future<DiscussionCommentContent> upvoteComment(String commentId) async {
    try {
      final response = await callApi(
        "post-service/discussions/comments/$commentId/upvote",
        'PUT',
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseMap = jsonDecode(utf8.decode(response.bodyBytes));
        final BaseResponseApi baseResponse = BaseResponseApi.fromJson(responseMap);

        if (baseResponse.code != 1000) {
          throw Exception(baseResponse.message);
        }

        return DiscussionCommentContent.fromJson(baseResponse.result);
      } else {
        Log.debug(response.body);
        throw Exception('Failed to upvote comment');
      }
    } catch (error) {
      Log.debug('Error upvoting comment: $error');
      rethrow;
    }
  }
}
