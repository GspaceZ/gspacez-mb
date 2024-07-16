import 'dart:convert';
import 'package:untitled/service/config_api/config_api.dart';

Future<Map<String, dynamic>> updateProfile(String firstName, String lastName,
    String country, String city, String dob, String address, String token) async {
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
      token: token,
    );
    if(response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to update profile');
    }

  }
  catch (error) {
    print('Error: $error');
    rethrow;
  }

}
