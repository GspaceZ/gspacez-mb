import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/model/admin_squad.dart';
import 'package:untitled/model/squad_setting.dart';

class SquadResponse {
  String id;
  String name;
  String privacy;
  String? avatarUrl;
  String? description;
  String tagName;
  SquadSetting setting;
  int totalPosts;
  int totalMembers;
  List<AdminSquad> adminList;
  bool canBeEdited;
  String joinStatus;
  DateTime createdAt;
  DateTime? updatedAt;

  SquadResponse({
    required this.id,
    required this.name,
    required this.privacy,
    this.avatarUrl,
    this.description,
    required this.tagName,
    required this.setting,
    required this.totalPosts,
    required this.totalMembers,
    required this.adminList,
    required this.canBeEdited,
    required this.joinStatus,
    required this.createdAt,
    this.updatedAt,
  });

  factory SquadResponse.fromJson(Map<String, dynamic> json) {
    return SquadResponse(
      id: json['id'],
      name: json['name'],
      privacy: json['privacy'],
      avatarUrl: json['avatarUrl'] as String? ?? AppConstants.urlImageDefault,
      description: json['description'] as String?,
      tagName: json['tagName'] as String,
      setting: SquadSetting.fromJson(json['setting']),
      totalPosts: json['totalPosts'],
      totalMembers: json['totalMembers'],
      adminList: (json['adminList'] as List<dynamic>)
          .map((e) => AdminSquad.fromJson(e))
          .toList(),
      canBeEdited: json['canBeEdited'],
      joinStatus: json['joinStatus'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'privacy': privacy,
      'avatarUrl': avatarUrl,
      'description': description,
      'tagName': tagName,
      'setting': setting.toJson(),
      'totalPosts': totalPosts,
      'totalMembers': totalMembers,
      'adminList': adminList.map((e) => e.toJson()).toList(),
      'canBeEdited': canBeEdited,
      'joinStatus': joinStatus,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt?.toUtc().toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'SquadResponse(id: $id, name: $name, privacy: $privacy, avatarUrl: $avatarUrl, description: $description, tagName: $tagName, totalPosts: $totalPosts, totalMembers: $totalMembers, canBeEdited: $canBeEdited, joinStatus: $joinStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
