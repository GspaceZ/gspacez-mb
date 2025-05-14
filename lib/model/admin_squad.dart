import 'package:untitled/constants/appconstants.dart';

class AdminSquad {
  final String id;
  final String profileId;
  final String profileName;
  final String profileTag;
  final String squadId;
  final String joinStatus;
  final String role;
  final DateTime joinedAt;
  String avatarUrl = AppConstants.urlImageDefault;

  AdminSquad({
    required this.id,
    required this.profileId,
    required this.profileName,
    required this.profileTag,
    required this.squadId,
    required this.joinStatus,
    required this.role,
    required this.joinedAt,
  });

  factory AdminSquad.fromJson(Map<String, dynamic> json) {
    return AdminSquad(
      id: json['id'] as String? ?? '',
      profileId: json['profileId'] as String? ?? '',
      profileName: json['profileName'] as String? ?? '',
      profileTag: json['profileTag'] as String? ?? '',
      squadId: json['squadId'] as String? ?? '',
      joinStatus: json['joinStatus'] as String? ?? '',
      role: json['role'] as String? ?? '',
      joinedAt: DateTime.parse(
          json['joinedAt'] as String? ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profileId': profileId,
      'profileName': profileName,
      'squadId': squadId,
      'joinStatus': joinStatus,
      'role': role,
      'joinedAt': joinedAt,
    };
  }

  @override
  String toString() {
    return 'AdminSquad(id: $id, profileId: $profileId, profileName: $profileName, squadId: $squadId, joinStatus: $joinStatus, role: $role, joinedAt: $joinedAt)';
  }
}
