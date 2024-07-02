import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/api/api.dart';
import 'package:untitled/model/User.dart';

Future<Map<String, dynamic>> signIn(String email, String password) async {
  final url = Uri.parse(
      'http://fakebook-be-f5688a2538c3.herokuapp.com/api/v1/identity/auth/login');

  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
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
    throw Exception("auth.sign_in_messages.generic");
  }
}

Future<Map<String, dynamic>> signUpUser(User user) async {
  try {
    final response = await callApi(
      'v1/identity/users/register',
      'POST',
      data: user.toJson(),
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(response.body);
      return responseData;
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception('Failed to sign up user: ${errorData['message']}');
    }
  } catch (error) {
    print('Error: $error');
    throw error;
  }

}