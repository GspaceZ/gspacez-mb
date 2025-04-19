Map<String, dynamic> convertContent(String markdownText) {
  final imageRegex = RegExp(r'!\[.*?\]\((.*?)\)');
  final videoRegex = RegExp(r'\[video\]\((.*?)\)');

  List<String> imageUrls = [];
  List<String> videoUrls = [];

  // get imageUrls
  for (final match in imageRegex.allMatches(markdownText)) {
    imageUrls.add(match.group(1)!);
  }

  // get videoUrls
  for (final match in videoRegex.allMatches(markdownText)) {
    videoUrls.add(match.group(1)!);
  }

  // get text
  String text = markdownText
      .replaceAll(imageRegex, '')
      .replaceAll(videoRegex, '')
      .trim();

  return {
    "text": text,
    "imageUrls": imageUrls,
    "videoUrls": videoUrls,
  };
}

String convertToMarkdown(Map<String, dynamic> content) {
  String text = content["text"] ?? "";
  List<String> imageUrls = List<String>.from(content["imageUrls"] ?? []);
  List<String> videoUrls = List<String>.from(content["videoUrls"] ?? []);

  // add images to markdown
  for (var url in imageUrls) {
    text += '\n![image]($url)';
  }

  // add video to markdown
  for (var url in videoUrls) {
    text += '\n[video]($url)';
  }

  return text;
}

