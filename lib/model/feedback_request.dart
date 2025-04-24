class FeedbackRequest {
  final String content;
  final int rate;

  FeedbackRequest({required this.content, required this.rate});

  Map<String, dynamic> toJson() => {
    'content': content,
    'rate': rate,
  };
}
