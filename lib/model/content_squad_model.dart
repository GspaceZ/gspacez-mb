import 'package:untitled/model/squad_setting.dart';

class ContentSquadModel {
  String name;
  String tagName;
  String? avatarUrl;
  String privacy;
  String? description;
  SquadSetting? setting;

  ContentSquadModel({
    required this.name,
    required this.tagName,
    this.avatarUrl,
    required this.privacy,
    this.description,
    this.setting,
  });

  factory ContentSquadModel.fromJson(Map<String, dynamic> json) {
    return ContentSquadModel(
      name: json['name'] as String,
      tagName: json['tagName'] as String,
      avatarUrl: json['avatarUrl'] as String,
      privacy: json['privacy'] as String,
      description: json['description'] as String,
      setting: SquadSetting.fromJson(json['setting']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tagName': tagName,
      'avatarUrl': avatarUrl,
      'privacy': privacy,
      'description': description,
      'setting': setting,
    };
  }

  @override
  String toString() {
    return 'ContentSquadModel(name: $name, tagName: $tagName, avatarUrl: $avatarUrl, privacy: $privacy, description: $description, setting: $setting)';
  }
}
