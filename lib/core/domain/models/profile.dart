import 'package:latlong2/latlong.dart';

class Profile {
  final int id;
  final String handle;
  final String? displayName;
  final String? biography;
  final String avatarUrl;
  final String? backgroundUrl;
  final LatLng position;
  final int listenerCount;
  final String color; // For UI purposes

  Profile({
    required this.id,
    required this.handle,
    this.displayName,
    this.biography,
    required this.avatarUrl,
    this.backgroundUrl,
    required this.position,
    required this.listenerCount,
    required this.color,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as int,
      handle: json['handle'] as String,
      displayName: json['displayName'] as String?,
      biography: json['biography'] as String?,
      avatarUrl: json['avatar'] as String,
      backgroundUrl: json['background'] as String?,
      position: LatLng(
        json['position']['latitude'] as double,
        json['position']['longitude'] as double,
      ),
      listenerCount: json['listeners'] as int,
      color: json['color'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'handle': handle,
      'displayName': displayName,
      'biography': biography,
      'avatar': avatarUrl,
      'background': backgroundUrl,
      'position': {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
      'listeners': listenerCount,
      'color': color,
    };
  }
}