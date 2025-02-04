import 'package:untitled/constants/appconstants.dart';

class CommentResponse {
  final String id;
  final String postId;
  final String profileId;
  final ContentComment content;
  final String? parentId;
  final String profileName;
  final String profileImageUrl;
  final String? createdAt;
  final String? updatedAt;

  CommentResponse({
    required this.id,
    required this.postId,
    required this.profileId,
    required this.content,
    this.parentId,
    required this.profileName,
    required this.profileImageUrl,
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
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class ContentComment {
  final String text;
  final List<String> images;
  final List<String> videos;

  ContentComment({
    required this.text,
    required this.images,
    required this.videos,
  });

  factory ContentComment.fromJson(Map<String, dynamic> json) {
    return ContentComment(
      text: json['text'],
      images: List<String>.from(json['images']),
      videos: List<String>.from(json['videos']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'images': images,
      'videos': videos,
    };
  }
}
