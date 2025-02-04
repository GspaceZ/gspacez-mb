import 'package:untitled/model/comment_response.dart';

class CommentModel {
  final String profileName;
  final String profileImageUrl;
  final ContentComment contentComment;
  final String createdAt;

  CommentModel(
      {required this.profileName,
      required this.profileImageUrl,
      required this.contentComment,
      required this.createdAt});

  toCommentResponse() {
    return CommentResponse(
      id: '',
      postId: '',
      profileId: '',
      content: contentComment,
      profileName: profileName,
      profileImageUrl: profileImageUrl,
      createdAt: createdAt,
    );
  }
}
