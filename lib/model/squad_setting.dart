class SquadSetting {
  bool allowPostModeration;
  bool allowChangeProfileAccessibility;
  bool allowChangeInteraction;

  SquadSetting({
    required this.allowPostModeration,
    required this.allowChangeProfileAccessibility,
    required this.allowChangeInteraction,
  });

  factory SquadSetting.fromJson(Map<String, dynamic> json) {
    return SquadSetting(
      allowPostModeration: json['allowPostModeration'] as bool,
      allowChangeProfileAccessibility: json['allowChangeProfileAccessibility'] as bool,
      allowChangeInteraction: json['allowChangeInteraction'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allowPostModeration': allowPostModeration,
      'allowChangeProfileAccessibility': allowChangeProfileAccessibility,
      'allowChangeInteraction': allowChangeInteraction,
    };
  }

  @override
  String toString() {
    return 'SquadSetting(allowPostModeration: $allowPostModeration, allowChangeProfileAccessibility: $allowChangeProfileAccessibility, allowChangeInteraction: $allowChangeInteraction)';
  }
}