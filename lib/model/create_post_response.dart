import 'package:untitled/model/content_post_model.dart';

import 'comment_response.dart';

class CreatePostResponse {
  String id;
  String type;
  String? privacy;
  ContentPostModel content;
  String? profileId;
  String? avatarUrl;
  List<CommentResponse>? comments;
  int? shares;
  List<String>? hashTags;
  String? feeling;
  String? location;
  int trendingPoint;
  DateTime createdAt;
  DateTime updatedAt;
  bool hidden;

  CreatePostResponse({
    required this.id,
    required this.type,
    this.privacy,
    required this.content,
    this.profileId,
    this.avatarUrl,
    this.comments,
    this.shares,
    this.hashTags,
    this.feeling,
    this.location,
    required this.trendingPoint,
    required this.createdAt,
    required this.updatedAt,
    required this.hidden,
  });

  factory CreatePostResponse.fromJson(Map<String, dynamic> json) {
    return CreatePostResponse(
      id: json['id'],
      type: json['type'],
      privacy: json['privacy'],
      content: ContentPostModel.fromJson(json['content']),
      profileId: json['profileId'],
      avatarUrl: json['avatarUrl'] ?? '',
      comments: json['comments'] != null
          ? List<CommentResponse>.from(json['comments'])
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
      'avatarUrl': avatarUrl,
      'comments': comments,
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
    return 'PostModel{id: $id, type: $type, privacy: $privacy, content: $content, profileId: $profileId, avatarUrl: $avatarUrl, comments: $comments, shares: $shares, hashTags: $hashTags, feeling: $feeling, location: $location, trendingPoint: $trendingPoint, createdAt: $createdAt, updatedAt: $updatedAt, hidden: $hidden}';
  }
}
