class AIChatResponse {
  final String sessionId;
  final String profileId;
  final String nameChatSession;
  final List<AIChatMessage>? messages;
  final String? content;

  AIChatResponse({
    this.content,
    required this.sessionId,
    required this.profileId,
    required this.nameChatSession,
    required this.messages,
  });

  factory AIChatResponse.fromJson(Map<String, dynamic> json) {
    return AIChatResponse(
      sessionId: json['sessionId'] ?? '',
      profileId: json['profileId'] ?? '',
      nameChatSession: json['nameChatSession'] ?? '',
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => AIChatMessage.fromJson(e))
          .toList(),
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'profileId': profileId,
      'nameChatSession': nameChatSession,
      'messages': messages,
      'content': content,
    };
  }

  @override
  String toString() {
    return 'AIChatResponse(sessionId: $sessionId, profileId: $profileId, nameChatSession: $nameChatSession, messages: $messages), content: $content)';
  }
}

class AIChatMessage {
  final String id;
  final String sessionId;
  final String profileId;
  final String message;
  final String nameChatSession;
  final String role;
  final DateTime createdAt;

  AIChatMessage({
    required this.id,
    required this.sessionId,
    required this.profileId,
    required this.message,
    required this.nameChatSession,
    required this.role,
    required this.createdAt,
  });

  factory AIChatMessage.fromJson(Map<String, dynamic> json) {
    return AIChatMessage(
      id: json['id'] ?? '',
      sessionId: json['sessionId'] ?? '',
      profileId: json['profileId'] ?? '',
      message: json['message'] ?? '',
      nameChatSession: json['nameChatSession'] ?? '',
      role: json['role'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'profileId': profileId,
      'message': message,
      'nameChatSession': nameChatSession,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
