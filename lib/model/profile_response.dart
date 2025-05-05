class ProfileResponse {
  final String id;
  final String firstName;
  final String lastName;
  final String? dob;
  final String? phone;
  final String? country;
  final String? city;
  final String? address;
  final String? description;
  final String? avatarUrl;
  final String updatedAt;

  ProfileResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.dob,
    this.phone,
    this.country,
    this.city,
    this.address,
    this.description,
    this.avatarUrl,
    required this.updatedAt,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String? ?? '',
      dob: json['dob'] as String?,
      phone: json['phone'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      description: json['description'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      updatedAt: json['updatedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob,
      'phone': phone,
      'country': country,
      'city': city,
      'address': address,
      'description': description,
      'avatarUrl': avatarUrl,
      'updatedAt': updatedAt,
    };
  }
}
