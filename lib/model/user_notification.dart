class UserNotification {
  final String id;
  final String profileId;
  final String? profileName;
  final String? email;
  final String? profileImageUrl;

  UserNotification({
    required this.id,
    required this.profileId,
    this.profileName,
    this.email,
    this.profileImageUrl,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['id'],
      profileId: json['profileId'],
      profileName: json['profileName'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }
}
