import 'package:untitled/constants/appconstants.dart';

class UserResponseModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final bool noPassword;
  final List<Role> roles;
  final avatarUrl = AppConstants.urlImageDefault;

  UserResponseModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.noPassword,
    required this.roles,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      id: json['id'],
      email: json['email'] as String? ?? "",
      firstName: json['firstName'],
      lastName: json['lastName'],
      noPassword: json['noPassword'],
      roles: (json['roles'] as List)
          .map((roleJson) => Role.fromJson(roleJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'noPassword': noPassword,
        'roles': roles.map((role) => role.toJson()).toList(),
      };
}

class Role {
  final String name;
  final String description;
  final List<String> permissions;

  Role({
    required this.name,
    required this.description,
    required this.permissions,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      name: json['name'],
      description: json['description'],
      permissions: List<String>.from(json['permissions']),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'permissions': permissions,
      };
}
