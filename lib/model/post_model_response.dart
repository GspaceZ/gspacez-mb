import 'package:untitled/model/content_post_model.dart';

class PostModel {
  String id;
  String type;
  String? privacy;
  ContentPostModel content;
  String? profileId;
  String profileName;
  String? avatarUrl;
  List<String>? commentIds;
  int? shares;
  List<String>? hashTags;
  String? feeling;
  String? location;
  int trendingPoint;
  DateTime createdAt;
  DateTime updatedAt;
  bool hidden;

  PostModel({
    required this.id,
    required this.type,
    this.privacy,
    required this.content,
    this.profileId,
    required this.profileName,
    this.avatarUrl,
    this.commentIds,
    this.shares,
    this.hashTags,
    this.feeling,
    this.location,
    required this.trendingPoint,
    required this.createdAt,
    required this.updatedAt,
    required this.hidden,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      type: json['type'],
      privacy: json['privacy'],
      content: ContentPostModel.fromJson(json['content']),
      profileId: json['profileId'],
      profileName: json['profileName'],
      avatarUrl: json['avatarUrl'] ?? '',
      commentIds: json['commentIds'] != null
          ? List<String>.from(json['commentIds'])
          : null,
      shares: json['shares'],
      hashTags:
          json['hashTags'] != null ? List<String>.from(json['hashTags']) : null,
      feeling: json['feeling'],
      location: json['location'],
      trendingPoint: json['trendingPoint'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      hidden: json['hidden'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'privacy': privacy,
      'content': content.toJson(),
      'profileId': profileId,
      'profileName': profileName,
      'avatarUrl': avatarUrl,
      'commentIds': commentIds,
      'shares': shares,
      'hashTags': hashTags,
      'feeling': feeling,
      'location': location,
      'trendingPoint': trendingPoint,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'hidden': hidden,
    };
  }

  @override
  String toString() {
    return 'PostModel{id: $id, type: $type, privacy: $privacy, content: $content, profileId: $profileId, profileName: $profileName, avatarUrl: $avatarUrl, commentIds: $commentIds, shares: $shares, hashTags: $hashTags, feeling: $feeling, location: $location, trendingPoint: $trendingPoint, createdAt: $createdAt, updatedAt: $updatedAt, hidden: $hidden}';
  }
}
