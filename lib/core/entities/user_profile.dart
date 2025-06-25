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

  factory UserProfile.fromJson(final Map<String, dynamic> json) => UserProfile(
      handle: json['handle'] ?? '',
      displayName: json['displayName'] ?? '',
      biography: json['biography'] ?? '',
      avatarLink: json['avatarLink'] ?? '',
      backgroundLink: json['backgroundLink'] ?? '',
      location: json['location'] ?? '',
      spotifyId: json['spotifyId'] ?? '',
      position: _parsePosition(json),
      color: json['color'],
      listeners: json['listeners'],
    );

  static LatLng _parsePosition(final Map<String, dynamic> json) {
    if (json['position'] != null) {
      return json['position'] as LatLng;
    }
    
    if (json['presence'] != null) {
      final Map<String, dynamic> presence = json['presence'] as Map<String, dynamic>;
      
      final dynamic latValue = presence['latitude'];
      final dynamic lngValue = presence['longitude'];
      
      double lat, lng;
      
      if (latValue is String) {
        lat = double.parse(latValue);
      } else if (latValue is num) {
        lat = latValue.toDouble();
      } else {
        lat = 0.0;
      }
      
      if (lngValue is String) {
        lng = double.parse(lngValue);
      } else if (lngValue is num) {
        lng = lngValue.toDouble();
      } else {
        lng = 0.0;
      }
      
      return LatLng(lat, lng);
    }
    
    return const LatLng(0, 0);
  }

  Map<String, dynamic> toJson() => <String, dynamic> {
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
    final String? handle,
    final String? displayName,
    final String? biography,
    final String? avatarLink,
    final String? backgroundLink,
    final String? location,
    final String? spotifyId,
    final LatLng? position,
    final Color? color,
    final int? listeners,
  }) => UserProfile(
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
