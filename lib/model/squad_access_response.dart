class SquadAccessResponse {
  SquadAccessResponse({
    required this.squadId,
    required this.name,
    required this.tagName,
    this.avatarUrl,
    required this.accessedAt,
  });

  final String squadId;
  final String name;
  final String tagName;
  final String? avatarUrl;
  final DateTime accessedAt;

  factory SquadAccessResponse.fromJson(Map<String, dynamic> json) {
    return SquadAccessResponse(
      squadId: json['squadId'],
      name: json['name'],
      tagName: json['tagName'],
      avatarUrl: json['avatarUrl'] ?? '',
      accessedAt: DateTime.parse(json['accessedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'squadId': squadId,
      'name': name,
      'tagName': tagName,
      'avatarUrl': avatarUrl,
      'accessedAt': accessedAt,
    };
  }

  @override
  String toString() {
    return 'SquadAccessResponse(name: $name, tagName: $tagName, avatarUrl: $avatarUrl, squadId: $squadId, accessedAt: $accessedAt)';
  }
}
