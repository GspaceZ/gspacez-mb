import 'package:untitled/model/squad_setting.dart';

class SquadModel {
  SquadModel({
    required this.name,
    required this.tagName,
    required this.avatarUrl,
    this.id,
    this.privacy,
    this.setting,
  });

  final String name;
  final String tagName;
  final String avatarUrl;
  final String? id;
  final String? privacy;
  final SquadSetting? setting;

  factory SquadModel.fromJson(Map<String, dynamic> json) {
    return SquadModel(
      name: json['name'] ?? '',
      tagName: json['tagName'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      id: json['id'],
      privacy: json['privacy'],
      setting: json['setting'] != null
          ? SquadSetting.fromJson(json['setting'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagName': tagName,
      'avatarUrl': avatarUrl,
      'privacy': privacy,
      'setting': setting!.toJson(),
    };
  }

  factory SquadModel.fromProfileJson(Map<String, dynamic> json) {
    return SquadModel(
      name: json['name'] ?? '',
      tagName: json['tagName'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }

  @override
  String toString() {
    return 'SquadModel(name: $name, tagName: $tagName, avatarUrl: $avatarUrl, id: $id, privacy: $privacy, setting: $setting)';
  }
}
