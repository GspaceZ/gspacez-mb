class DiscussionResponse {
  final String id;
  final String profileId;
  final String profileTag;
  final String profileName;
  final String avatarUrl;
  final String title;
  final String content;
  final VoteResponse? voteResponse;
  final List<String> hashTags;
  final bool isOpen;
  final DateTime createdAt;
  final DateTime updatedAt;

  DiscussionResponse({
    required this.id,
    required this.profileId,
    required this.profileTag,
    required this.profileName,
    required this.avatarUrl,
    required this.title,
    required this.content,
    this.voteResponse,
    required this.hashTags,
    required this.isOpen,
    required this.createdAt,
    required this.updatedAt,
  });

  DiscussionResponse copyWith({
    String? id,
    String? profileId,
    String? profileTag,
    String? profileName,
    String? avatarUrl,
    String? title,
    String? content,
    VoteResponse? voteResponse,
    List<String>? hashTags,
    bool? isOpen,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DiscussionResponse(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      profileTag: profileTag ?? this.profileTag,
      profileName: profileName ?? this.profileName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      title: title ?? this.title,
      content: content ?? this.content,
      voteResponse: voteResponse ?? this.voteResponse,
      hashTags: hashTags ?? this.hashTags,
      isOpen: isOpen ?? this.isOpen,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory DiscussionResponse.fromJson(Map<String, dynamic> json) {
    return DiscussionResponse(
      id: json['id'],
      profileId: json['profileId'],
      profileTag: json['profileTag'],
      profileName: json['profileName'],
      avatarUrl: json['avatarUrl'],
      title: json['title'],
      content: json['content'],
      voteResponse: json['voteResponse'] != null
          ? VoteResponse.fromJson(json['voteResponse'])
          : null,  // Handle the case where voteResponse is null
      hashTags: List<String>.from(json['hashTags']),
      isOpen: json['isOpen'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profileId': profileId,
      'profileTag': profileTag,
      'profileName': profileName,
      'avatarUrl': avatarUrl,
      'title': title,
      'content': content,
      'voteResponse': voteResponse?.toJson(),
      'hashTags': hashTags,
      'isOpen': isOpen,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class VoteResponse {
  final String title;
  final List<VoteOption> options;
  final String? selectedOptionId;

  VoteResponse({
    required this.title,
    required this.options,
    this.selectedOptionId,
  });

  factory VoteResponse.fromJson(Map<String, dynamic> json) {
    return VoteResponse(
      title: json['title'],
      options: (json['options'] as List)
          .map((e) => VoteOption.fromJson(e))
          .toList(),
      selectedOptionId: json['selectedOptionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'options': options.map((e) => e.toJson()).toList(),
      'selectedOptionId': selectedOptionId,
    };
  }
}

class VoteOption {
  final String id;
  final String? value;
  final double percentage;

  VoteOption({
    required this.id,
    this.value,
    required this.percentage,
  });

  factory VoteOption.fromJson(Map<String, dynamic> json) {
    return VoteOption(
      id: json['id'],
      value: json['value'] ?? "",
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'percentage': percentage,
    };
  }
}
