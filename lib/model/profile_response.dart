class ProfileResponse {
  final String id;
  final String firstName;
  final String lastName;
  final String? dob;
  final String? phone;
  final String? country;
  final String? city;
  final String? address;
  final String? shortDescription;
  final String? fullDescription;
  final String? avatarUrl;
  final String createdAt;

  ProfileResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.dob,
    this.phone,
    this.country,
    this.city,
    this.address,
    this.shortDescription,
    this.fullDescription,
    this.avatarUrl,
    required this.createdAt,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      dob: json['dob'] as String?,
      phone: json['phone'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      shortDescription: json['shortDescription'] as String?,
      fullDescription: json['fullDescription'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: json['createdAt'] as String,
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
      'shortDescription': shortDescription,
      'fullDescription': fullDescription,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt,
    };
  }
}
