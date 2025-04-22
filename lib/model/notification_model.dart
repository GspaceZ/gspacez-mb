import 'package:untitled/model/user_notification.dart';

import 'comment_notification.dart';

enum NotificationType {
  REQUEST_JOIN,
  COMMENT,
  LIKE,
  DISLIKE,
}

NotificationType notificationTypeFromString(String type) {
  return NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == type,
    orElse: () => NotificationType.LIKE,
  );
}

class NotificationModel {
  final String id;
  final String profileId;
  final String content;
  final NotificationType type;
  final Entity entity;
  final String createdAt;
  final bool read;

  NotificationModel({
    required this.id,
    required this.profileId,
    required this.content,
    required this.type,
    required this.entity,
    required this.createdAt,
    required this.read,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final type = notificationTypeFromString(json['type'] ?? '');

    return NotificationModel(
      id: json['id'],
      profileId: json['profileId'],
      content: json['content'],
      type: type,
      entity: Entity.fromJson(json['entity']),
      createdAt: json['createdAt'],
      read: json['read'],
    );
  }
}

class Entity {
  final String? id;
  final String? postId;
  final String? commentId;
  final CommentNotification? commentRequest;
  final String? type;
  final String? reactType;
  final UserNotification sender;
  final UserNotification? receiver;
  final List<UserNotification>? receivers;
  final String? createdAt;

  Entity({
    this.id,
    this.postId,
    this.commentId,
    this.commentRequest,
    this.type,
    this.reactType,
    required this.sender,
    this.receiver,
    this.receivers,
    this.createdAt,
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      id: json['id'],
      postId: json['postId'],
      commentId: json['commentId'],
      commentRequest: json['commentRequest'] != null
          ? CommentNotification.fromJson(json['commentRequest'])
          : null,
      type: json['type'],
      reactType: json['reactType'],
      sender: UserNotification.fromJson(json['sender']),
      receiver: json['receiver'] != null ? UserNotification.fromJson(json['receiver']) : null,
      receivers: (json['receivers'] as List<dynamic>?)
          ?.map((e) => UserNotification.fromJson(e))
          .toList(),
      createdAt: json['createdAt'],
    );
  }
}

class NotificationReact {
  final String id;
  final String postId;
  final UserNotification receiver;
  final UserNotification sender;

  NotificationReact({
    required this.id,
    required this.postId,
    required this.receiver,
    required this.sender,
  });

  factory NotificationReact.fromJson(Map<String, dynamic> json) {
    return NotificationReact(
      id: json['id'],
      postId: json['postId'],
      receiver: UserNotification.fromJson(json['receiver']),
      sender: UserNotification.fromJson(json['sender']),
    );
  }
}

class NotificationComment {
  final String id;
  final String postId;
  final String commentId;
  final CommentNotification commentRequest;
  final UserNotification receiver;
  final UserNotification sender;
  final String createdAt;

  NotificationComment({
    required this.id,
    required this.postId,
    required this.commentId,
    required this.commentRequest,
    required this.receiver,
    required this.sender,
    required this.createdAt,
  });

  factory NotificationComment.fromJson(Map<String, dynamic> json) {
    return NotificationComment(
      id: json['id'],
      postId: json['postId'],
      commentId: json['commentId'],
      commentRequest: CommentNotification.fromJson(json['commentRequest']),
      receiver: UserNotification.fromJson(json['receiver']),
      sender: UserNotification.fromJson(json['sender']),
      createdAt: json['createdAt'],
    );
  }
}
