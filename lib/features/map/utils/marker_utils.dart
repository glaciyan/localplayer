// lib/features/map/utils/marker_utils.dart

import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

LatLng generateRandomLatLngWithinBounds(
  LatLngBounds bounds,
  List<LatLng> placedPoints, {
  double minDistance = 0.001,
  int maxAttempts = 20,
}) {
  final random = Random();

  for (int attempt = 0; attempt < maxAttempts; attempt++) {
    final lat = bounds.south + random.nextDouble() * (bounds.north - bounds.south);
    final lng = bounds.west + random.nextDouble() * (bounds.east - bounds.west);
    final candidate = LatLng(lat, lng);

    bool tooClose = placedPoints.any((point) {
      final distance = (candidate.latitude - point.latitude).abs() +
                       (candidate.longitude - point.longitude).abs();
      return distance < minDistance;
    });

    if (!tooClose) return candidate;
  }

  return LatLng(
    bounds.south + random.nextDouble() * (bounds.north - bounds.south),
    bounds.west + random.nextDouble() * (bounds.east - bounds.west),
  );
}

LatLngBounds expandBounds(LatLngBounds bounds, {double paddingDegrees = 0.05}) {
  return LatLngBounds(
    LatLng(bounds.south - paddingDegrees, bounds.west - paddingDegrees),
    LatLng(bounds.north + paddingDegrees, bounds.east + paddingDegrees),
  );
}

double calculateScale(int listeners, {int maxListeners = 10000000}) {
  const double minScale = 0.8;
  const double maxScale = 1.4;

  double normalized = listeners / maxListeners;
  normalized = normalized.clamp(0.0, 1.0);
  return minScale + (maxScale - minScale) * normalized;
}