import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/data/local/token_data_source.dart';
import 'package:untitled/extensions/log.dart';
import 'package:untitled/model/base_response_api.dart';
import 'package:untitled/service/auth_service.dart';
import 'package:untitled/service/config_api/network_constant.dart';

Future<http.Response> callApi<T>(
  String url,
  String method, {
  Map<String, dynamic>? data,
  bool? isToken,
  String? contentType,
  Map<String, dynamic>? customHeaders,
}) async {
  final token = await TokenDataSource.instance.getToken();
  final Uri fullUrl = Uri.parse('${NetworkConstant.baseURL}$url');
  final headers = <String, String>{
    'Content-Type': contentType ?? AppConstants.json,
    if (token != null && isToken != null && isToken)
      'Authorization': 'Bearer $token',
    if (customHeaders != null) ...customHeaders,
  };
  late http.Response response;
  Log.info('request: "$fullUrl" \n$headers \n${jsonEncode(data)}');
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
      response =
          await http.delete(fullUrl, headers: headers, body: jsonEncode(data));
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
  Log.info('Response: ${utf8.decode(response.bodyBytes)}');
  Map<String, dynamic> responseMap =
      jsonDecode(utf8.decode(response.bodyBytes));
  final BaseResponseApi baseResponse = BaseResponseApi.fromJson(responseMap);
  if (baseResponse.code == 1401) {
    // Token expired
    final refreshToken = await LocalStorage.instance.userRefreshToken;
    final accessTokenExpired = await TokenDataSource.instance.getToken();
    if (refreshToken == null || accessTokenExpired == null) {
      return response;
    }
    await AuthService.instance.refreshToken();
    return callApi(url, method,
        data: data, isToken: isToken, contentType: contentType);
  }
  return response;
}
