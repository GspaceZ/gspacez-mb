import 'package:untitled/model/content_model.dart';

class CommentRequest {
  final String? parentId;
  final ContentModel content;

  CommentRequest({
    this.parentId,
    required this.content,
  });

  factory CommentRequest.fromJson(Map<String, dynamic> json) {
    return CommentRequest(
      parentId: json['parentId'] ?? '',
      content: ContentModel.fromJson(json['content']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment': {
        'parentId': parentId,
        'content': content.toJson()
      },
    };
  }

  @override
  String toString() {
    return 'CommentRequest{parentId: $parentId, content: ${content.toJson()}}';
  }
}
