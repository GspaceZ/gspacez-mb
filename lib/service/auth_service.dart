import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/model/user.dart';
import 'package:untitled/service/config_api/network_constant.dart';

import 'config_api/config_api.dart';

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
    if(response.statusCode == 200) {
      return responseData;
    } else {
      return throw Exception('Failed to sign up user');
    }

  } catch (error) {
    print('Error: $error');
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
Future<Map<String, dynamic>> sendMailActive( String email) async {
  try {
    final response = await callApi(
      "identity/auth/send-active",
      'POST',
      data: {
        'email': email,
        'url': NetworkConstant.BASE_URI_ACTIVE
      },
    );
    if(response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to send mail active');
    }
  }
  catch (error) {
    print('Error: $error');
    rethrow;
  }
}