import 'dart:convert';

import 'package:untitled/extensions/log.dart';
import 'package:untitled/model/admin_squad.dart';
import 'package:untitled/model/base_response_api.dart';
import 'package:untitled/service/config_api/config_api.dart';

import '../model/content_squad_model.dart';
import '../model/squad_access_response.dart';
import '../model/squad_model.dart';
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
      final BaseResponseApi baseResponse =
          BaseResponseApi.fromJson(responseMap);

      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }

      return SquadResponse.fromJson(baseResponse.result);
    } else {
      throw Exception('Failed to create squad');
    }
  }

  Future<SquadResponse> updateSquad(
      ContentSquadModel contentSquad, String tagName) async {
    final response = await callApi(
      "profile-service/squads/$tagName/update",
      "PUT",
      isToken: true,
      data: contentSquad.toJson(),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap =
          jsonDecode(utf8.decode(response.bodyBytes));
      final BaseResponseApi baseResponse =
          BaseResponseApi.fromJson(responseMap);

      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }

      return SquadResponse.fromJson(baseResponse.result);
    } else {
      throw Exception('Failed to update squad');
    }
  }

  Future<List<SquadModel>> getJoinedSquads(String profileTag) async {
    final response = await callApi(
      "profile-service/squads/joined/$profileTag",
      'GET',
      isToken: true,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap =
          jsonDecode(utf8.decode(response.bodyBytes));
      final BaseResponseApi baseResponse =
          BaseResponseApi.fromJson(responseMap);
      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }
      final List<SquadModel> joinedSquads = baseResponse.result
          .map((squad) => SquadModel.fromProfileJson(squad))
          .toList()
          .cast<SquadModel>();
      return joinedSquads;
    } else {
      throw Exception('Failed to get joined squads');
    }
  }

  Future<List<SquadAccessResponse>> getLastAccess() async {
    final response = await callApi(
      "profile-service/squads/squad-access",
      'GET',
      isToken: true,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap =
          jsonDecode(utf8.decode(response.bodyBytes));
      final BaseResponseApi baseResponse =
          BaseResponseApi.fromJson(responseMap);
      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }
      final List<SquadAccessResponse> accessedSquads = baseResponse.result
          .map((squad) => SquadAccessResponse.fromJson(squad))
          .toList()
          .cast<SquadAccessResponse>();
      return accessedSquads;
    } else {
      throw Exception('Failed to get accessed squads');
    }
  }

  Future<SquadResponse> getSquadInfo(String tagName) async {
    final response = await callApi(
      "profile-service/squads/$tagName/info",
      "GET",
      isToken: true,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap =
          jsonDecode(utf8.decode(response.bodyBytes));
      final BaseResponseApi baseResponse =
          BaseResponseApi.fromJson(responseMap);

      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }

      return SquadResponse.fromJson(baseResponse.result);
    } else {
      throw Exception('Failed to get squad info');
    }
  }

  Future<List<AdminSquad>> getOfficialMembers(String tagName) async {
    final response = await callApi(
      "profile-service/squads/$tagName/official-members",
      "GET",
      isToken: true,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap =
          jsonDecode(utf8.decode(response.bodyBytes));
      final BaseResponseApi baseResponse =
          BaseResponseApi.fromJson(responseMap);

      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }

      return (baseResponse.result["content"] as List)
          .map((e) => AdminSquad.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to get official members');
    }
  }

  Future<List<AdminSquad>> getPendingMembers(String tagName) async {
    final response = await callApi(
      "profile-service/squads/$tagName/pending-members",
      "GET",
      isToken: true,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap =
          jsonDecode(utf8.decode(response.bodyBytes));
      final BaseResponseApi baseResponse =
          BaseResponseApi.fromJson(responseMap);

      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }

      return (baseResponse.result["content"] as List)
          .map((e) => AdminSquad.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to get pending members');
    }
  }

  Future<List<SquadResponse>> searchSquad(String query, int size) async {
    final response = await callApi(
      "profile-service/squads/search?size=$size&page=0&searchText=$query",
      "GET",
      isToken: true,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      final BaseResponseApi baseResponse =
          BaseResponseApi.fromJson(responseMap);
      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }
      final List<SquadResponse> squads = baseResponse.result['content']
          .map((user) => SquadResponse.fromJson(user))
          .toList()
          .cast<SquadResponse>();
      return squads;
    } else {
      Log.debug(response.body);
      throw Exception('Failed to search squads');
    }
  }

  Future<bool> approveSquadMember(String nameSquads, String profileId) async {
    final response = await callApi(
      "profile-service/squads/$nameSquads/approve-request",
      "POST",
      data: {
        "profileIds": [profileId],
      },
      isToken: true,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap =
          jsonDecode(utf8.decode(response.bodyBytes));
      final BaseResponseApi baseResponse =
          BaseResponseApi.fromJson(responseMap);

      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }

      return true;
    } else {
      throw Exception('Failed to approve squad member');
    }
  }

  Future<bool> rejectSquadMember(String nameSquad, String profileId) async {
    final response = await callApi(
      "profile-service/squads/$nameSquad/reject-request",
      "POST",
      data: {
        "profileIds": [profileId],
      },
      isToken: true,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap =
          jsonDecode(utf8.decode(response.bodyBytes));
      final BaseResponseApi baseResponse =
          BaseResponseApi.fromJson(responseMap);

      if (baseResponse.code != 1000) {
        throw Exception(baseResponse.message);
      }

      return true;
    } else {
      throw Exception('Failed to reject squad member');
    }
  }
}
