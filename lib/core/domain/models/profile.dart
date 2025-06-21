import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class Profile {
  final int id;
  final DateTime createdAt;
  final DateTime updateAt;
  final int ownerId;
  final int profileOwnerIndex;
  final String handle;
  final String? displayName;
  final String? biography;
  final String? spotifyId;
  final int? realPresenceId;
  final int? fakePresenceId;
  
  // Optional relations (not typically needed for map display)
  final List<int>? swipesMadeIds;
  final List<int>? swipesReceivedIds;
  
  // UI-specific fields (not in backend schema but needed for frontend)
  final String avatarUrl;
  final String? backgroundUrl;
  final LatLng position;
  final int listeners;
  final Color color;

  Profile({
    required this.id,
    required this.createdAt,
    required this.updateAt,
    required this.ownerId,
    required this.profileOwnerIndex,
    required this.handle,
    this.displayName,
    this.biography,
    this.spotifyId,
    this.realPresenceId,
    this.fakePresenceId,
    this.swipesMadeIds,
    this.swipesReceivedIds,
    required this.avatarUrl,
    this.backgroundUrl,
    required this.position,
    required this.listeners,
    required this.color,
  });

  factory Profile.fromJson(final Map<String, dynamic> json) => Profile(
    id: json['id'] as int,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updateAt: DateTime.parse(json['updateAt'] as String),
    ownerId: json['ownerId'] as int,
    profileOwnerIndex: json['profileOwnerIndex'] as int,
    handle: json['handle'] as String,
    displayName: json['displayName'] as String?,
    biography: json['biography'] as String?,
    spotifyId: json['spotifyId'] as String?,
    realPresenceId: json['realPresenceId'] as int?,
    fakePresenceId: json['fakePresenceId'] as int?,
    swipesMadeIds: json['swipesMadeIds'] as List<int>?,
    swipesReceivedIds: json['swipesReceivedIds'] as List<int>?,
    avatarUrl: json['avatar'] as String,
    backgroundUrl: json['background'] as String?,
    position: LatLng(
      (json['position'] as Map<String, dynamic>)['latitude'] as double,
      (json['position'] as Map<String, dynamic>)['longitude'] as double,
    ),
    listeners: json['listeners'] as int,
    color: Color(int.parse(json['color'] as String)),
  );

  Map<String, dynamic> toJson() => <String, dynamic> {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'updateAt': updateAt.toIso8601String(),
    'ownerId': ownerId,
    'profileOwnerIndex': profileOwnerIndex,
    'handle': handle,
    'displayName': displayName,
    'biography': biography,
    'spotifyId': spotifyId,
    'realPresenceId': realPresenceId,
    'fakePresenceId': fakePresenceId,
    'swipesMadeIds': swipesMadeIds,
    'swipesReceivedIds': swipesReceivedIds,
    'avatar': avatarUrl,
    'background': backgroundUrl,
    'position': <String, dynamic> {
      'latitude': position.latitude,
      'longitude': position.longitude,
    }, 
    'listeners': listeners,
    'color': color,
  };
}