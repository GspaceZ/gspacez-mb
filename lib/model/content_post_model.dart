class ContentPostModel {
  String? text;
  List<String> imageUrls;
  List<String> videoUrls;
  String? location;
  String? feeling;
  String? privacy;
  List<String>? hashTags;

  ContentPostModel({
    this.text,
    required this.imageUrls,
    required this.videoUrls,
    this.location,
    this.feeling,
    this.privacy,
    this.hashTags,
  });

  factory ContentPostModel.fromJson(Map<String, dynamic> json) {
    return ContentPostModel(
      text: json['text'],
      imageUrls:
          json['imageUrls'] != null ? List<String>.from(json['imageUrls']) : [],
      videoUrls:
          json['videoUrls'] != null ? List<String>.from(json['videoUrls']) : [],
      location: json['location'],
      feeling: json['feeling'],
      privacy: json['privacy'],
      hashTags: json['hashTags'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'imageUrls': imageUrls,
      'videoUrls': videoUrls,
      'location': location,
      'feeling': feeling,
      'privacy': privacy,
      'hashTags': hashTags,
    };
  }

  @override
  String toString() {
    return 'ContentPostModel{text: $text, imageUrls: $imageUrls, videoUrls: $videoUrls, location: $location, feeling: $feeling, privacy: $privacy, hashTags: $hashTags}';
  }
}
