class CommentNotification {
  final ContentNotification content;
  final String? parentId;

  CommentNotification({required this.content, this.parentId});

  factory CommentNotification.fromJson(Map<String, dynamic> json) {
    return CommentNotification(
      content: ContentNotification.fromJson(json['content']),
      parentId: json['parentId'] ?? '',
    );
  }
}

class ContentNotification {
  final String text;
  final List<String>? imageUrls;
  final List<String>? videoUrls;

  ContentNotification({
    required this.text,
    this.imageUrls,
    this.videoUrls,
  });

  factory ContentNotification.fromJson(Map<String, dynamic> json) {
    return ContentNotification(
      text: json['text'] ?? '',
      imageUrls: json['imageUrls'] != null
          ? List<String>.from(json['imageUrls'])
          : null,
      videoUrls: json['videoUrls'] != null
          ? List<String>.from(json['videoUrls'])
          : null,
    );
  }
}
