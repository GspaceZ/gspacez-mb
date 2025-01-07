class ContentPostModel {
  String? text;
  List<String> imageUrls;
  List<String> videoUrls;
  String? location;
  String? feeling;
  String? activity;
  String? tag;

  ContentPostModel({
    this.text,
    required this.imageUrls,
    required this.videoUrls,
    this.location,
    this.feeling,
    this.activity,
    this.tag,
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
      activity: json['activity'],
      tag: json['tag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'imageUrls': imageUrls,
      'videoUrls': videoUrls,
      'location': location,
      'feeling': feeling,
      'activity': activity,
      'tag': tag,
    };
  }

  @override
  String toString() {
    return 'ContentPostModel{text: $text, imageUrls: $imageUrls, videoUrls: $videoUrls, location: $location, feeling: $feeling, activity: $activity, tag: $tag}';
  }
}
