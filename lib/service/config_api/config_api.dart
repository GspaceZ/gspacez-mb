import 'dart:convert';
import 'package:http/http.dart' as http;

import 'network_constant.dart';

Future<http.Response> callApi<T>(

    String url,
    String method, {
      Map<String, dynamic>? data,
    }) async {
  try {
    final Uri fullUrl = Uri.parse('${NetworkConstant.BASE_URL}' '$url');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      // 'Cookie': 'JSESSIONID=56A129D4F8266C25C357A5237C993405',
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

    return response;
  } catch (error) {
    rethrow;
  }
}
