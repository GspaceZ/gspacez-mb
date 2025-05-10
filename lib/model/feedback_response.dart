class FeedbackResponse {
  final String id;
  final String profileId;
  final String content;
  final int rate;
  final DateTime createdAt;

  FeedbackResponse({
    required this.id,
    required this.profileId,
    required this.content,
    required this.rate,
    required this.createdAt,
  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      id: json['id'],
      profileId: json['profileId'],
      content: json['content'],
      rate: json['rate'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profileId': profileId,
      'content': content,
      'rate': rate,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'FeedbackResponse(id: $id, profileId: $profileId, content: $content, rate: $rate, createdAt: $createdAt)';
  }
}
