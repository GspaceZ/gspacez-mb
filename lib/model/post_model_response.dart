import 'package:untitled/model/content_model.dart';
import 'package:untitled/model/squad_model.dart';

import 'comment_response.dart';

class PostModelResponse {
  String id;
  String profileId;
  String? profileTag;
  String profileName;
  String? avatarUrl;
  ContentModel content;
  SquadModel squad;
  List<CommentResponse>? comments;
  List<String>? hashTags;
  String? privacy;
  String? type;
  DateTime createdAt;
  DateTime updatedAt;
  String? title;
  String? previewImage;
  int totalLike;
  int totalDislike;
  bool liked;
  bool disliked;
  bool? canBeInteracted;

  PostModelResponse({
    required this.id,
    required this.profileId,
    this.profileTag,
    required this.profileName,
    this.avatarUrl,
    required this.content,
    required this.squad,
    this.comments,
    this.hashTags,
    this.privacy,
    this.type,
    required this.createdAt,
    required this.updatedAt,
    this.title,
    this.previewImage,
    required this.totalLike,
    required this.totalDislike,
    required this.liked,
    required this.disliked,
    this.canBeInteracted,
  });

  factory PostModelResponse.fromJson(Map<String, dynamic> json) {
    return PostModelResponse(
      id: json['id'],
      profileId: json['profileId'],
      profileTag: json['profileTag'] ?? "",
      profileName: json['profileName'],
      avatarUrl: json['avatarUrl'],
      content: ContentModel.fromJson(json['content']),
      comments: json['comments'] != null
          ? (json['comments'] as List)
              .map((e) => CommentResponse.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      squad: json['squad'] != null
          ? SquadModel.fromJson(json['squad'])
          : SquadModel.fromProfileJson(json['squad']),
      hashTags: List<String>.from(json['hashTags'] ?? []),
      privacy: json['privacy'],
      type: json['type'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      title: json['title'],
      previewImage: json['previewImage'],
      totalLike: json['totalLike'],
      totalDislike: json['totalDislike'],
      liked: json['liked'],
      disliked: json['disliked'],
      canBeInteracted: json['canBeInteracted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profileId': profileId,
      'profileTag': profileTag,
      'profileName': profileName,
      'avatarUrl': avatarUrl,
      'comments': comments,
      'content': content.toJson(),
      'squad': squad,
      'hashTags': hashTags,
      'privacy': privacy,
      'type': type,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'title': title,
      'previewImage': previewImage,
      'totalLike': totalLike,
      'totalDislike': totalDislike,
      'liked': liked,
      'disliked': disliked,
      'canBeInteracted': canBeInteracted,
    };
  }

  @override
  String toString() {
    return 'PostModel{id: $id, type: $type, privacy: $privacy, content: $content, squad: $squad, profileId: $profileId, profileTag: $profileTag, profileName: $profileName, avatarUrl: $avatarUrl, comments: $comments, title: $title, previewImage: $previewImage, hashTags: $hashTags, totalLike: $totalLike, totalDislike: $totalDislike, liked: $liked, createdAt: $createdAt, updatedAt: $updatedAt, disliked: $disliked, canBeInteracted: $canBeInteracted}';
  }
}
