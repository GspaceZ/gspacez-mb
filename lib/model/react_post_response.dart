class ReactPostResponse {
  String currentReact;
  int totalLikes;
  int totalDislikes;

  ReactPostResponse({
    required this.currentReact,
    required this.totalLikes,
    required this.totalDislikes,
  });

  factory ReactPostResponse.fromJson(Map<String, dynamic> json) {
    return ReactPostResponse(
      currentReact: json['currentReact'],
      totalLikes: json['totalLikes'],
      totalDislikes: json['totalDislikes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentReact': currentReact,
      'totalLikes': totalLikes,
      'totalDislikes': totalDislikes,
    };
  }

  @override
  String toString() {
    return 'ReactPostResponse(currentReact: $currentReact, totalLikes: $totalLikes, totalDislikes: $totalDislikes)';
  }
}