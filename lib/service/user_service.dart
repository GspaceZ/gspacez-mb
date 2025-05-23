import 'dart:convert';

import 'package:tuple/tuple.dart';
import 'package:untitled/extensions/log.dart';
import 'package:untitled/model/base_response_api.dart';
import 'package:untitled/model/feedback_response.dart';
import 'package:untitled/model/profile_response.dart';
import 'package:untitled/model/streak_response.dart';
import 'package:untitled/service/config_api/config_api.dart';

import '../model/ai_chat_response.dart';
import '../model/notification_model.dart';
import '../model/post_model_response.dart';

class UserService {
  // Private constructor
  UserService._privateConstructor();

  // Static instance
  static final UserService _instance = UserService._privateConstructor();

  // Static getter for the instance
  static UserService get instance => _instance;

  // UUID generator
  // final Uuid _uuid = const Uuid();

  Future<Map<String, dynamic>> updateProfile(String firstName, String lastName,
      String country, String dob, String description) async {
    try {
      final response = await callApi(
        "profile-service/info",
        'PUT',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'country': country,
          'dob': dob,
          'description': description,
        },
        isToken: true,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        Log.debug(response.body);
        throw Exception('Failed to update profile');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateAvatar(String avatarUrl) async {
    try {
      final response = await callApi(
        "profile-service/info/avatar",
        'POST',
        data: {'avatarUrl': avatarUrl},
        isToken: true,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        Log.debug(response.body);
        throw Exception('Failed to update avatar');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<void> createNewPassword(String password) async {
    try {
      final response = await callApi(
        "identity/users/create-password",
        'POST',
        data: {
          'password': password,
        },
        isToken: true,
      );
      if (response.statusCode == 200) {
        return;
      } else {
        Log.debug(response.body);
        throw Exception('Failed to create new password');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<bool> isNeededCreatePassword() async {
    try {
      final response = await callApi(
        "identity/users/my-info",
        'GET',
        isToken: true,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['result']['noPassword'];
      } else {
        Log.debug(response.body);
        throw Exception('Failed to check needed create password');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<ProfileResponse> getMe() async {
    try {
      final response = await callApi(
        "profile-service/info",
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
        final profile = ProfileResponse.fromJson(baseResponse.result);
        return profile;
      } else {
        Log.debug(response.body);
        throw Exception('Failed to get me');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<ProfileResponse> getProfile(String profileTag) async {
    try {
      final response = await callApi(
        "profile-service/info/$profileTag",
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
        final profile = ProfileResponse.fromJson(baseResponse.result);
        return profile;
      } else {
        Log.debug(response.body);
        throw Exception('Failed to get profile');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<Tuple2<List<PostModelResponse>, int>> getPostsByProfile(
      String profileTag, int pageNum, int pageSize) async {
    final response = await callApi(
      "post-service/posts/own-post/$profileTag?pageNum=$pageNum&pageSize=$pageSize",
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
      return Tuple2(posts, baseResponse.result['totalElements']);
    } else {
      throw Exception('Failed to get posts by profile');
    }
  }

  Future<Tuple2<List<PostModelResponse>, int>> getLikedPostsByProfile(
      String profileId, int size, int page) async {
    final response = await callApi(
      "post-service/posts/liked/by/$profileId?size=$size&page=$page",
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
      return Tuple2(posts, baseResponse.result['totalElements']);
    } else {
      throw Exception('Failed to get liked posts by profile');
    }
  }

  Future<BaseResponseApi> sendRequest(String tagName) async {
    try {
      final response = await callApi(
        "profile-service/squads/$tagName/send-request",
        'POST',
        isToken: true,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = jsonDecode(response.body);
        final BaseResponseApi baseResponse =
            BaseResponseApi.fromJson(responseMap);
        if (baseResponse.code != 1000) {
          throw Exception(baseResponse.message);
        }
        return baseResponse;
      } else {
        Log.debug(response.body);
        throw Exception('Failed to send request');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<BaseResponseApi> cancelRequest(String tagName) async {
    try {
      final response = await callApi(
        "profile-service/squads/$tagName/cancel-request",
        'POST',
        isToken: true,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = jsonDecode(response.body);
        final BaseResponseApi baseResponse =
            BaseResponseApi.fromJson(responseMap);
        if (baseResponse.code != 1000) {
          throw Exception(baseResponse.message);
        }
        return baseResponse;
      } else {
        Log.debug(response.body);
        throw Exception('Failed to cancel request');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<BaseResponseApi> leaveSquad(String tagName) async {
    try {
      final response = await callApi(
        "profile-service/squads/$tagName/leave-squad",
        'POST',
        isToken: true,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = jsonDecode(response.body);
        final BaseResponseApi baseResponse =
            BaseResponseApi.fromJson(responseMap);
        if (baseResponse.code != 1000) {
          throw Exception(baseResponse.message);
        }
        return baseResponse;
      } else {
        Log.debug(response.body);
        throw Exception('Failed to leave squad');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<List<NotificationModel>> getNotifications(String profileId) async {
    final response = await callApi(
      "notification/get-notification/$profileId",
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
      final List<NotificationModel> notifications = baseResponse.result
          .map((notification) => NotificationModel.fromJson(notification))
          .toList()
          .cast<NotificationModel>();
      return notifications;
    } else {
      throw Exception('Failed to get notifications by profile');
    }
  }

  Future<StreakResponse> getStreak(String profileTag) async {
    try {
      final response = await callApi(
        "profile-service/info/$profileTag/streak",
        'GET',
        isToken: true,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = jsonDecode(response.body);
        final BaseResponseApi baseResponse =
            BaseResponseApi.fromJson(responseMap);
        if (baseResponse.code != 1000) {
          throw Exception(baseResponse.message);
        }
        final streak = StreakResponse.fromJson(baseResponse.result);
        return streak;
      } else {
        Log.debug(response.body);
        throw Exception('Failed to get profile');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<void> sendFeedback(String content, int rate) async {
    try {
      final response = await callApi(
        "profile-service/feedback/create",
        'POST',
        data: {
          'content': content,
          'rate': rate,
        },
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Log.debug('Feedback sent successfully');
      } else {
        Log.debug(response.body);
        throw Exception('Failed to send feedback');
      }
    } catch (error) {
      Log.debug('Error sending feedback: $error');
      rethrow;
    }
  }

  Future<List<ProfileResponse>> searchUser(
      String query, int size, int page) async {
    try {
      final response = await callApi(
        "profile-service/info/search?size=$size&page=$page&searchText=$query",
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
        final List<ProfileResponse> users = baseResponse.result['content']
            .map((user) => ProfileResponse.fromJson(user))
            .toList()
            .cast<ProfileResponse>();
        return users;
      } else {
        Log.debug(response.body);
        throw Exception('Failed to search user');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<List<FeedbackResponse>> getAllFeedbacks() async {
    try {
      final response = await callApi(
        "profile-service/feedback/all",
        'GET',
        isToken: true,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap =
            jsonDecode(utf8.decode(response.bodyBytes));
        final BaseResponseApi baseResponse =
            BaseResponseApi.fromJson(responseMap);
        if (baseResponse.code != 1000 && baseResponse.code != 200) {
          throw Exception(baseResponse.message);
        }
        final List<FeedbackResponse> feedbacks = baseResponse.result
            .map((item) => FeedbackResponse.fromJson(item))
            .toList()
            .cast<FeedbackResponse>();
        return feedbacks;
      } else {
        Log.debug(response.body);
        throw Exception('Failed to get all feedbacks');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<List<FeedbackResponse>> getMyFeedbacks() async {
    try {
      final response = await callApi(
        "profile-service/feedback/me",
        'GET',
        isToken: true,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap =
            jsonDecode(utf8.decode(response.bodyBytes));
        final BaseResponseApi baseResponse =
            BaseResponseApi.fromJson(responseMap);
        if (baseResponse.code != 1000 && baseResponse.code != 200) {
          throw Exception(baseResponse.message);
        }
        final List<FeedbackResponse> feedbacks = baseResponse.result
            .map((item) => FeedbackResponse.fromJson(item))
            .toList()
            .cast<FeedbackResponse>();
        return feedbacks;
      } else {
        Log.debug(response.body);
        throw Exception('Failed to get my feedbacks');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<BaseResponseApi> deleteMyFeedback(String id) async {
    try {
      final response = await callApi(
        "profile-service/feedback/$id",
        'DELETE',
        isToken: true,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = jsonDecode(response.body);
        final BaseResponseApi baseResponse =
            BaseResponseApi.fromJson(responseMap);

        if (baseResponse.code != 1000 && baseResponse.code != 200) {
          throw Exception(baseResponse.message);
        }

        return baseResponse;
      } else {
        Log.debug(response.body);
        throw Exception('Failed to delete my feedback');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<List<AIChatResponse>> getAllChat() async {
    try {
      final response = await callApi(
        "profile-service/google-gemini/chat/all",
        'GET',
        isToken: true,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap =
            jsonDecode(utf8.decode(response.bodyBytes));
        final BaseResponseApi baseResponse =
            BaseResponseApi.fromJson(responseMap);
        if (baseResponse.code != 1000 && baseResponse.code != 200) {
          throw Exception(baseResponse.message);
        }
        final List<AIChatResponse> allChats = baseResponse.result
            .map((item) => AIChatResponse.fromJson(item))
            .toList()
            .cast<AIChatResponse>();
        return allChats;
      } else {
        Log.debug(response.body);
        throw Exception('Failed to get all chats');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<AIChatResponse> chatAI(String content, String sessionId) async {
    // final sessionId = _uuid.v4();

    try {
      final response = await callApi(
        "profile-service/google-gemini/chat",
        'POST',
        isToken: true,
        data: {
          'sessionId': sessionId,
          'content': content,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap =
            jsonDecode(utf8.decode(response.bodyBytes));
        final BaseResponseApi baseResponse =
            BaseResponseApi.fromJson(responseMap);
        if (baseResponse.code != 1000 && baseResponse.code != 200) {
          throw Exception(baseResponse.message);
        }
        final result = AIChatResponse.fromJson(baseResponse.result);
        return result;
      } else {
        Log.debug(response.body);
        throw Exception('Failed to chat with AI');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<AIChatResponse> getHistoryChat(String id) async {
    try {
      final response = await callApi(
        "profile-service/google-gemini/chat/$id",
        'GET',
        isToken: true,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap =
            jsonDecode(utf8.decode(response.bodyBytes));
        final BaseResponseApi baseResponse =
            BaseResponseApi.fromJson(responseMap);
        if (baseResponse.code != 1000 && baseResponse.code != 200) {
          throw Exception(baseResponse.message);
        }
        final result = AIChatResponse.fromJson(baseResponse.result);
        return result;
      } else {
        Log.debug(response.body);
        throw Exception('Failed to get history chat');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }
}
