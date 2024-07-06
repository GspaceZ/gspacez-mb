import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/model/user.dart';

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

Future<http.Response> signUpUser(User user) async {
  final response = await http.post(
    Uri.parse(
        'http://fakebook-be-f5688a2538c3.herokuapp.com/api/v1/identity/users/register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(user.toJson()),
  );

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response,
    // then parse the JSON.
    return response;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to sign up user');
  }
}
