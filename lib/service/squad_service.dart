import 'dart:convert';

import 'package:untitled/model/base_response_api.dart';
import 'package:untitled/service/config_api/config_api.dart';

import '../model/content_squad_model.dart';
import '../model/squad_response.dart';

class SquadService {
  //private constructor
  SquadService._privateConstructor();

  //static instance
  static final SquadService _instance = SquadService._privateConstructor();

  //static getter for the instance
  static SquadService get instance => _instance;

  Future<SquadResponse> createSquad(ContentSquadModel contentSquad) async {
    final response = await callApi(
      "profile-service/squads/create",
      "POST",
      isToken: true,
      data: contentSquad.toJson(),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap =
      jsonDecode(utf8.decode(response.bodyBytes));
      final BaseResponseApi baseResponse = BaseResponseApi.fromJson(responseMap);

      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }

      return SquadResponse.fromJson(baseResponse.result);
    } else {
      throw Exception('Failed to create squad');
    }
  }
}
