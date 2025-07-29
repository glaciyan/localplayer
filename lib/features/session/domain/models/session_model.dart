import 'package:latlong2/latlong.dart';

class SessionModel {
  final int id;
  final DateTime createdAt;
  final DateTime updateAt;
  final String status;
  final String name;
  final LatLng? position;

  SessionModel({
    required this.id,
    required this.createdAt,
    required this.updateAt,
    required this.status,
    required this.name,
    this.position,
  });

  factory SessionModel.fromJson(final Map<String, dynamic> json) {
    LatLng? sessionPosition;
    if (json['presence'] != null) {
      final Map<String, dynamic> presence = json['presence'] as Map<String, dynamic>;
      final double lat = double.tryParse(presence['latitude'].toString()) ?? 0;
      final double lng = double.tryParse(presence['longitude'].toString()) ?? 0;
      sessionPosition = LatLng(lat, lng);
    }

    return SessionModel(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updateAt: DateTime.parse(json['updateAt'] as String),
      status: json['status'] as String,
      name: json['name'] as String,
      position: sessionPosition,
    );
  }
}
