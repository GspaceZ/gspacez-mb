class DiscussionFormRequest {
  final String title;
  final String content;
  final List<String> hashTags;
  final VoteRequest? voteRequest;

  DiscussionFormRequest({
    required this.title,
    required this.content,
    required this.hashTags,
    this.voteRequest,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'hashTags': hashTags,
    if (voteRequest != null) 'voteRequest': voteRequest!.toJson(),
  };
}

class VoteRequest {
  final String title;
  final List<String?> options;

  VoteRequest({
    required this.title,
    required this.options,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'options': options,
  };
}
