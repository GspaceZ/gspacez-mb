import 'package:flutter/material.dart';

enum Role { user, bot }

class ChatAIModel {
  final List<String> message;
  final Role role;
  final String name;
  final String avatar;
  final Color color;

  ChatAIModel({
    required this.message,
    required this.role,
    required this.name,
    required this.avatar,
    required this.color,
  });
}
