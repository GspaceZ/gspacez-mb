class ContentPostModel {
  String text;

  ContentPostModel({
    required this.text,
  });

  factory ContentPostModel.fromJson(Map<String, dynamic> json) {
    return ContentPostModel(
      text: json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }

  @override
  String toString() {
    return 'ContentPostModel{text: $text}';
  }
}
