import 'package:untitled/model/comment_response.dart';

class CommentModel {
  final String profileName;
  final String profileImageUrl;
  final ContentComment contentComment;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CommentModel(
      {
        required this.profileName,
        required this.profileImageUrl,
        required this.contentComment,
        required this.createdAt,
        this.updatedAt,
      });

  toCommentResponse() {
    return CommentResponse(
      id: '',
      postId: '',
      profileId: '',
      content: contentComment,
      profileName: profileName,
      profileImageUrl: profileImageUrl,
      createdAt: createdAt.toUtc(),
      updatedAt: updatedAt?.toUtc(),
    );
  }
}
