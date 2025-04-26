class SquadSetting {
  bool allowPostModeration;
  bool allowChangeProfileAccessibility;
  bool allowPostInteraction;

  SquadSetting({
    required this.allowPostModeration,
    required this.allowChangeProfileAccessibility,
    required this.allowPostInteraction,
  });

  factory SquadSetting.fromJson(Map<String, dynamic> json) {
    return SquadSetting(
      allowPostModeration: json['allowPostModeration'] as bool? ?? false,
      allowChangeProfileAccessibility:
          json['allowChangeProfileAccessibility'] as bool? ?? false,
      allowPostInteraction: json['allowPostInteraction'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allowPostModeration': allowPostModeration,
      'allowChangeProfileAccessibility': allowChangeProfileAccessibility,
      'allowPostInteraction': allowPostInteraction,
    };
  }

  @override
  String toString() {
    return 'SquadSetting(allowPostModeration: $allowPostModeration, allowChangeProfileAccessibility: $allowChangeProfileAccessibility, allowPostInteraction: $allowPostInteraction)';
  }
}
