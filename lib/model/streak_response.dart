class StreakResponse {
  final String id;
  final String profileId;
  final int currentStreak;
  final DateTime lastActiveDate;

  StreakResponse({
    required this.id,
    required this.profileId,
    required this.currentStreak,
    required this.lastActiveDate,
  });

  factory StreakResponse.fromJson(Map<String, dynamic> json) {
    return StreakResponse(
      id: json['id'],
      profileId: json['profileId'],
      currentStreak: json['currentStreak'],
      lastActiveDate: DateTime.parse(json['lastActiveDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profileId': profileId,
      'currentStreak': currentStreak,
      'lastActiveDate': lastActiveDate.toUtc().toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'StreakResponse(id: $id, profileId: $profileId, currentStreak: $currentStreak, lastActiveDate: $lastActiveDate,)';
  }
}
