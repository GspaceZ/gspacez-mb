class DiscussionCommentResponse {
  final int totalElements;
  final int totalPages;
  final List<DiscussionCommentContent> content;

  DiscussionCommentResponse({
    required this.totalElements,
    required this.totalPages,
    required this.content,
  });

  factory DiscussionCommentResponse.fromJson(Map<String, dynamic> json) {
    return DiscussionCommentResponse(
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
      content: (json['content'] as List<dynamic>)
          .map((e) => DiscussionCommentContent.fromJson(e))
          .toList(),
    );
  }
}

class DiscussionCommentContent {
  final String id;
  final String profileId;
  final String profileName;
  final String profileTag;
  final String avatarUrl;
  final String content;
  final int totalUpvote;
  final bool canBeEdited;
  final bool isUpvote;

  DiscussionCommentContent({
    required this.id,
    required this.profileId,
    required this.profileName,
    required this.profileTag,
    required this.avatarUrl,
    required this.content,
    required this.totalUpvote,
    required this.canBeEdited,
    required this.isUpvote,
  });

  factory DiscussionCommentContent.fromJson(Map<String, dynamic> json) {
    return DiscussionCommentContent(
      id: json['id'],
      profileId: json['profileId'],
      profileName: json['profileName'],
      profileTag: json['profileTag'],
      avatarUrl: json['avatarUrl'],
      content: json['content'],
      totalUpvote: json['totalUpvote'],
      canBeEdited: json['canBeEdited'],
      isUpvote: json['isUpvote'],
    );
  }
}
