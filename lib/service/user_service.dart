import 'dart:convert';
import 'package:untitled/extensions/log.dart';
import 'package:untitled/model/base_response_api.dart';
import 'package:untitled/model/profile_response.dart';
import 'package:untitled/service/config_api/config_api.dart';
import '../model/post_model_response.dart';

class UserService {
  // Private constructor
  UserService._privateConstructor();

  // Static instance
  static final UserService _instance = UserService._privateConstructor();

  // Static getter for the instance
  static UserService get instance => _instance;

  Future<Map<String, dynamic>> updateProfile(String firstName, String lastName,
      String country, String city, String dob, String address) async {
    try {
      final response = await callApi(
        "profile-service/info",
        'PUT',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'country': country,
          'city': city,
          'dob': dob,
          'address': address,
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

  Future<ProfileResponse> getProfile() async {
    try {
      final response = await callApi(
        "profile-service/info",
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

  Future<List<PostModelResponse>> getPostsByProfile(String profileId, int pageNum, int pageSize) async {
    final response = await callApi(
      "post-service/posts/own-post/$profileId?pageNum=$pageNum&pageSize=$pageSize",
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
      throw Exception('Failed to get posts by profile');
    }
  }

  Future<List<PostModelResponse>> getLikedPostsByProfile(String profileId, int size, int page) async {
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
      final List<PostModelResponse> posts = baseResponse.result
          .map((post) => PostModelResponse.fromJson(post))
          .toList()
          .cast<PostModelResponse>();
      return posts;
    } else {
      throw Exception('Failed to get liked posts by profile');
    }
  }
}
