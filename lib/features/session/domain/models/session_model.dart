import 'package:latlong2/latlong.dart';

class SessionModel {
  final int id;
  final DateTime createdAt;
  final String status;
  final String name;
  final LatLng position;

  SessionModel({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.name,
    required this.position,
  });

  factory SessionModel.fromJson(final Map<String, dynamic> json) {
    final Map<String, dynamic>? presence = json['presence'] as Map<String, dynamic>?;
    final double lat = presence != null
        ? double.tryParse(presence['latitude'].toString()) ?? 0
        : 0;
    final double lng = presence != null
        ? double.tryParse(presence['longitude'].toString()) ?? 0
        : 0;
    return SessionModel(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String,
      name: json['name'] as String,
      position: LatLng(lat, lng),
    );
  }
}
