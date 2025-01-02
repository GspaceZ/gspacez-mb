import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/data/local/token_data_source.dart';
import 'package:untitled/extensions/log.dart';
import 'package:untitled/main.dart';
import 'package:untitled/model/user.dart';
import 'package:untitled/provider/language_provider.dart';
import 'package:untitled/service/config_api/network_constant.dart';

import 'config_api/config_api.dart';

class AuthService {
  // Private constructor
  AuthService._privateConstructor();

  // Static instance
  static final AuthService _instance = AuthService._privateConstructor();

  // Static getter for the instance
  static AuthService get instance => _instance;

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final response = await callApi(
      "identity/auth/login",
      'POST',
      data: {
        'email': email,
        'password': password,
      },
    );

    final responseData = jsonDecode(response.body);

    if (responseData['code'] == 1000) {
      // Success
      return responseData;
    } else if (responseData['code'] == 1005) {
      // User not existed error
      throw Exception("auth.sign_in_messages.user");
    } else if (responseData['code'] == 1014) {
      // Password incorrect error
      throw Exception("auth.sign_in_messages.password");
    } else {
      // Other errors
      throw Exception("auth.sign_in_messages.fail");
    }
  }

  Future<Map<String, dynamic>> signUpUser(User user) async {
    try {
      final response = await callApi(
        'identity/users/register',
        'POST',
        data: user.toJson(),
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return responseData;
      } else {
        return throw Exception('Failed to sign up user');
      }
    } catch (error) {
      Log.error(error.toString());
      rethrow;
    }
  }

  Future<http.Response> forgetPassword(String email) async {
    final response = await callApi(
      "identity/auth/forget-password",
      'POST',
      data: {
        'email': email,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send forget password request');
    }
    return response;
  }

  Future<http.Response> verifyOtp(String email, String otp) async {
    final response = await callApi(
      "identity/auth/verify-otp",
      'POST',
      data: {
        'email': email,
        'otp': otp,
      },
    );
    return response;
  }

  Future<http.Response> resetPassword(String email, String password) async {
    final response = await callApi(
      "identity/auth/reset-password",
      'POST',
      data: {
        'email': email,
        'newPassword': password,
      },
    );
    return response;
  }

  Future<Map<String, dynamic>> sendMailActive(String email) async {
    try {
      final response = await callApi(
        "identity/auth/send-active",
        'POST',
        data: {'email': email, 'url': NetworkConstant.baseURIActive},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        Log.debug(response.body);
        throw Exception('Failed to send mail active');
      }
    } catch (error) {
      Log.debug('Error: $error');
      rethrow;
    }
  }

  Future<bool> sendCodeToServer(String code) async {
    BuildContext context = navigatorKey.currentContext!;
    Locale currentLocale = context.read<LanguageProvider>().locale;
    String locale = currentLocale.languageCode;
    final uri = "identity/auth/oauth2" "?code=$code";
    final response = await callApi(uri, 'POST',
        data: {
          'code': code,
        },
        customHeaders: {
          'locale': locale,
          'origin': 'https://gspacez.blog',
        },
        contentType: AppConstants.formUrlEncoded);
    if (response.statusCode == 200) {
      TokenDataSource.instance
          .saveToken(jsonDecode(response.body)['result']['token']);
      LocalStorage.instance.saveUserRefreshToken(
          jsonDecode(response.body)['result']['refreshToken']);
      return true;
    } else {
      return false;
    }
  }
}
