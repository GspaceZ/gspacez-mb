import '../utils/date_utils.dart';

class SquadResponse {
  String id;
  String name;
  String privacy;
  String? description;
  String adminName;
  String adminId;
  DateTime createdAt;
  DateTime? updatedAt;

  SquadResponse({
    required this.id,
    required this.name,
    required this.privacy,
    this.description,
    required this.adminName,
    required this.adminId,
    required this.createdAt,
    this.updatedAt,
  });

  factory SquadResponse.fromJson(Map<String, dynamic> json) {

    return SquadResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      privacy: json['privacy'] as String,
      description: json['description'] as String,
      adminName: json['adminName'] as String,
      adminId: json['adminId'] as String,
      createdAt: DateUtils.parseDate(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateUtils.parseDate(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'privacy': privacy,
      'description': description,
      'adminName': adminName,
      'adminId': adminId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'SquadResponse(id: $id, name: $name, privacy: $privacy, description: $description, adminName: $adminName, adminId: $adminId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
