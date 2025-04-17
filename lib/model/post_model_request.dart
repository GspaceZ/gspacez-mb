class PostModelRequest {
  String text;
  String privacy;
  String? previewImage;
  String squadTagName;
  String title;
  List<String>? hashTags;

  PostModelRequest({
    required this.text,
    required this.privacy,
    required this.title,
    required this.squadTagName,
    this.previewImage,
    this.hashTags,
  });

  factory PostModelRequest.fromJson(Map<String, dynamic> json) {
    return PostModelRequest(
      text: json['text'],
      privacy: json['privacy'],
      previewImage: json['previewImage'] ?? '',
      squadTagName: json['squadTagName'],
      title: json['title'],
      hashTags: json['hashTags'] != null ? List<String>.from(json['hashTags']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'privacy': privacy,
      'previewImage': previewImage,
      'squadTagName': squadTagName,
      'title': title,
      'hashTags': hashTags,
    };
  }

  @override
  String toString() {
    return 'ContentPostModel{text: $text, privacy: $privacy, previewImage: $previewImage, squadTagName: $squadTagName, title: $title, hashTags: $hashTags}';
  }
}
