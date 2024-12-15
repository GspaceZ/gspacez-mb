import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:untitled/extensions/log.dart';
import 'package:untitled/service/config_api/network_constant.dart';

Future<http.Response> callApi<T>(
  String url,
  String method, {
  Map<String, dynamic>? data,
  String? token,
}) async {
  try {
    Log.debug("Data: $data");
    final Uri fullUrl = Uri.parse('${NetworkConstant.BASE_URL}' '$url');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    late http.Response response;

    switch (method.toUpperCase()) {
      case 'POST':
        response =
            await http.post(fullUrl, headers: headers, body: jsonEncode(data));
        break;
      case 'PUT':
        response =
            await http.put(fullUrl, headers: headers, body: jsonEncode(data));
        break;
      case 'DELETE':
        response = await http.delete(fullUrl,
            headers: headers, body: jsonEncode(data));
        break;
      case 'PATCH':
        response =
            await http.patch(fullUrl, headers: headers, body: jsonEncode(data));
        break;
      case 'GET':
      default:
        response = await http.get(fullUrl, headers: headers);
        break;
    }
    Log.debug('Response: ${response.body}');
    return response;
  } catch (error) {
    Log.error('Error: $error');
    rethrow;
  }
}
