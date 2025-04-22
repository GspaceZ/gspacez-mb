class ContentModel {
  String text;

  ContentModel({
    required this.text,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
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
    return 'ContentModel{text: $text}';
  }
}
