import 'dart:convert';
import 'package:untitled/extensions/log.dart';
import 'package:untitled/service/config_api/config_api.dart';

class UserService {
  // Private constructor
  UserService._privateConstructor();

  // Static instance
  static final UserService _instance = UserService._privateConstructor();

  // Static getter for the instance
  static UserService get instance => _instance;

  Future<Map<String, dynamic>> updateProfile(
      String firstName,
      String lastName,
      String country,
      String city,
      String dob,
      String address,
      String token) async {
    try {
      final response = await callApi(
        "profile/users",
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

  Future<Map<String, dynamic>> updateAvatar(
      String avatarUrl, String token) async {
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
}
