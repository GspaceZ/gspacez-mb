class CreatePostRequest {
  final String text;
  final List<String> imageUrls;
  final List<String> videoUrls;
  final String feeling;
  final List<String> hashTags;
  final String privacy;
  final String location;

  CreatePostRequest({
    required this.text,
    required this.imageUrls,
    required this.videoUrls,
    required this.feeling,
    required this.hashTags,
    required this.privacy,
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'imageUrls': imageUrls,
      'videoUrls': videoUrls,
      'feeling': feeling,
      'hashTags': hashTags,
      'privacy': privacy,
      'location': location,
    };
  }
}
