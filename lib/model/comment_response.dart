import 'package:untitled/constants/appconstants.dart';

class CommentResponse {
  final String id;
  final String postId;
  final String profileId;
  final ContentComment content;
  final String? parentId;
  final String profileName;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CommentResponse({
    required this.id,
    required this.postId,
    required this.profileId,
    required this.content,
    this.parentId,
    required this.profileName,
    this.profileImageUrl,
    required this.createdAt,
    this.updatedAt,
  });

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    return CommentResponse(
      id: json['id'],
      postId: json['postId'],
      profileId: json['profileId'],
      content: ContentComment.fromJson(json['content']),
      parentId: json['parentId'],
      profileName: json['profileName'],
      profileImageUrl: json['profileImageUrl'] ?? AppConstants.urlImageDefault,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'profileId': profileId,
      'content': content.toJson(),
      'parentId': parentId,
      'profileName': profileName,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt?.toUtc().toIso8601String(),
    };
  }
}

class ContentComment {
  final String text;

  ContentComment({
    required this.text,
  });


  factory ContentComment.fromJson(Map<String, dynamic> json) {
    return ContentComment(
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}
