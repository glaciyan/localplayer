// features/match/domain/entities/user_profile.dart
class UserProfile {
  final String name;
  final String avatarLink;
  final String description;
  final String location;
  final String backgroundLink;

  const UserProfile({
    required this.name,
    required this.avatarLink,
    required this.description,
    required this.location,
    required this.backgroundLink,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      avatarLink: json['avatarLink'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      backgroundLink: json['backgroundLink'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'avatarLink': avatarLink,
    'description': description,
    'location': location,
    'backgroundLink': backgroundLink,
  };

  String getBckgroundLink() {
    return backgroundLink.isNotEmpty ? backgroundLink : avatarLink;
  }

  String getAvatarLink() {
    return avatarLink.isNotEmpty ? avatarLink : backgroundLink;
  }
}
