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
  final String profileTag;
  final String? avatarUrl;
  final String updatedAt;
  final List<SocialMedia> socialMedias;

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
    required this.profileTag,
    required this.updatedAt,
    required this.socialMedias,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    var socialMediaList = json['socialMedias'] as List? ?? [];
    List<SocialMedia> socialMedias = socialMediaList.map((item) {
      return SocialMedia.fromJson(item as Map<String, dynamic>);
    }).toList();

    return ProfileResponse(
      id: json['id'] as String,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      dob: json['dob'] as String?,
      phone: json['phone'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      description: json['description'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      profileTag: json['profileTag'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      socialMedias: socialMedias,
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
      'socialMedias': socialMedias.map((socialMedia) => socialMedia.toJson()).toList(),
    };
  }
}

class SocialMedia {
  final String platform;
  final String url;

  SocialMedia({
    required this.platform,
    required this.url,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      platform: json['platform'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'url': url,
    };
  }
}
