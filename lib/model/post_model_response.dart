import 'package:untitled/model/content_post_model.dart';
import 'comment_response.dart';

class PostModelResponse {
  String id;
  String profileId;
  String profileName;
  String avatarUrl;
  ContentPostModel content;
  List<CommentResponse>? comments;
  List<String>? hashTags;
  String? privacy;
  String? type;
  DateTime createdAt;
  DateTime updatedAt;
  String title;
  int totalLike;
  int totalDislike;
  bool liked;
  bool disliked;

  PostModelResponse({
    required this.id,
    required this.profileId,
    required this.profileName,
    required this.avatarUrl,
    required this.content,
    this.comments,
    this.hashTags,
    this.privacy,
    this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.totalLike,
    required this.totalDislike,
    required this.liked,
    required this.disliked,
  });

  factory PostModelResponse.fromJson(Map<String, dynamic> json) {
    return PostModelResponse(
      id: json['id'],
      profileId: json['profileId'],
      profileName: json['profileName'],
      avatarUrl: json['avatarUrl'],
      content: ContentPostModel.fromJson(json['content']),
        comments: json['comments'] != null
            ? (json['comments'] as List)
            .map((e) => CommentResponse.fromJson(e as Map<String, dynamic>))
            .toList()
            : null,
      hashTags: json['hashTags'] != null ? List<String>.from(json['hashTags']) : null,
      privacy: json['privacy'],
      type: json['type'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      title: json['title'],
      totalLike: json['totalLike'],
      totalDislike: json['totalDislike'],
      liked: json['liked'],
      disliked: json['disliked']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profileId': profileId,
      'profileName': profileName,
      'avatarUrl': avatarUrl,
      'comments': comments,
      'content': content.toJson(),
      'hashTags': hashTags,
      'privacy': privacy,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'title': title,
      'totalLike': totalLike,
      'totalDislike': totalDislike,
      'liked': liked,
      'disliked': disliked,
    };
  }

  @override
  String toString() {
    return 'PostModel{id: $id, type: $type, privacy: $privacy, content: $content, profileId: $profileId, profileName: $profileName, avatarUrl: $avatarUrl, comments: $comments, title: $title, hashTags: $hashTags, totalLike: $totalLike, totalDislike: $totalDislike, liked: $liked, createdAt: $createdAt, updatedAt: $updatedAt, disliked: $disliked}';
  }
}
