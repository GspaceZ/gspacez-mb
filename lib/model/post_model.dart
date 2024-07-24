class PostModel {
  final String author;
  final String urlAvatar;
  final String content;
  final List<String>? urlImages;
  final String? urlVideo;
  int? likes;
  int? comments;
  int? shares;

  PostModel({
    required this.author,
    required this.urlAvatar,
    required this.content,
    this.urlImages,
    this.urlVideo,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      author: json['author'],
      urlAvatar: json['urlAvatar'],
      content: json['content'],
      urlImages: List<String>.from(json['urlImages']),
      urlVideo: json['urlVideo'],
      likes: json['likes'],
      comments: json['comments'],
      shares: json['shares'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'urlAvatar': urlAvatar,
      'content': content,
      'urlImages': urlImages,
      'urlVideo': urlVideo,
      'likes': likes,
      'comments': comments,
      'shares': shares,
    };
  }
}
