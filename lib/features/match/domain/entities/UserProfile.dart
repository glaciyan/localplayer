// features/match/domain/entities/user_profile.dart
class UserProfile {
  final String name;
  final int age;
  final String imageUrl;
  final String description;
  final String location;

  const UserProfile({
    required this.name,
    required this.age,
    required this.imageUrl,
    required this.description,
    required this.location,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      age: json['age'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'imageUrl': imageUrl,
    'description': description,
    'location': location,
  };
}
