// features/match/domain/entities/user_profile.dart
import 'dart:ui';

import 'package:latlong2/latlong.dart';

class UserProfile {
  final String handle;
  final String displayName;
  final String biography;
  final String avatarLink;
  final String backgroundLink;
  final String location;
  final String spotifyId;
  final LatLng position;
  final Color? color;
  final int? listeners;

  const UserProfile({
    required this.handle,
    required this.displayName,
    required this.biography,
    required this.avatarLink,
    required this.backgroundLink,
    required this.location,
    required this.spotifyId,
    required this.position,
    this.color,
    this.listeners,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      handle: json['handle'] ?? '',
      displayName: json['displayName'] ?? '',
      biography: json['biography'] ?? '',
      avatarLink: json['avatarLink'] ?? '',
      backgroundLink: json['backgroundLink'] ?? '',
      location: json['location'] ?? '',
      spotifyId: json['spotifyId'] ?? '',
      position: json['position'] as LatLng,
      color: json['color'],
      listeners: json['listeners'],
    );
  }

  Map<String, dynamic> toJson() => {
    'handle': handle,
    'displayName': displayName,
    'biography': biography,
    'avatarLink': avatarLink,
    'backgroundLink': backgroundLink,
    'location': location,
    'spotifyId': spotifyId,
    'position': position,
    'color': color,
    'listeners': listeners,
  };

  UserProfile copyWith({
    String? handle,
    String? displayName,
    String? biography,
    String? avatarLink,
    String? backgroundLink,
    String? location,
    String? spotifyId,
    LatLng? position,
    Color? color,
    int? listeners,
  }) {
    return UserProfile(
      handle: handle ?? this.handle,
      displayName: displayName ?? this.displayName,
      biography: biography ?? this.biography,
      avatarLink: avatarLink ?? this.avatarLink,
      backgroundLink: backgroundLink ?? this.backgroundLink,
      location: location ?? this.location,
      spotifyId: spotifyId ?? this.spotifyId,
      position: position ?? this.position,
      color: color ?? this.color,
      listeners: listeners ?? this.listeners,
    );
  }
}
