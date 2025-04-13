class ExploreModel {
  final String id;
  final String sourceName;
  final String author;
  final String title;
  final String description;
  final String url;
  final String? urlToImage;
  final DateTime publishedAt;
  final String content;
  final bool active;

  ExploreModel({
    required this.id,
    required this.sourceName,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.active,
  });

  factory ExploreModel.fromJson(Map<String, dynamic> json) {
    return ExploreModel(
      id: json['source']?['id'] ?? '',
      sourceName: json['source']?['name'] ?? '',
      author: json['author'] ?? '',
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: DateTime.parse(json['publishedAt']),
      content: json['content'] ?? '',
      active: json['active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': {
        'id': id,
        'name': sourceName,
      },
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt.toUtc().toIso8601String(),
      'content': content,
      'active': active,
    };
  }

  @override
  String toString() {
    return 'ExploreModel(source: $sourceName, author: $author, title: $title, url: $url)';
  }
}
