// lib/features/map/utils/marker_utils.dart

import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

LatLng generateRandomLatLngWithinBounds(
  final LatLngBounds bounds,
  final List<LatLng> placedPoints, {
  final double minDistance = 0.001,
  final int maxAttempts = 20,
}) {
  final Random random = Random();

  for (int attempt = 0; attempt < maxAttempts; attempt++) {
    final double lat = bounds.south + random.nextDouble() * (bounds.north - bounds.south);
    final double lng = bounds.west + random.nextDouble() * (bounds.east - bounds.west);
    final LatLng candidate = LatLng(lat, lng);

    final bool tooClose = placedPoints.any((final LatLng point) {
      final double distance = (candidate.latitude - point.latitude).abs() +
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

LatLngBounds expandBounds(final LatLngBounds bounds, {final double paddingDegrees = 0.05}) => LatLngBounds(
    LatLng(bounds.south - paddingDegrees, bounds.west - paddingDegrees),
    LatLng(bounds.north + paddingDegrees, bounds.east + paddingDegrees),
  );

double calculateScale(final int listeners, {final int maxListeners = 10000000}) {
  const double minScale = 0.8;
  const double maxScale = 1.4;

  double normalized = listeners / maxListeners;
  normalized = normalized.clamp(0.0, 1.0);
  return minScale + (maxScale - minScale) * normalized;
}

double calculateRadiusFromBounds(final LatLngBounds bounds) {
  // Calculate the diagonal distance of the visible bounds
  final double latDiff = (bounds.north - bounds.south).abs();
  final double lngDiff = (bounds.east - bounds.west).abs();
  
  // Convert to approximate kilometers (rough conversion)
  final double radiusKm = (latDiff + lngDiff) * 111.0; // 1 degree ≈ 111 km
  
  // Clamp to reasonable bounds (1km to 500km)
  return radiusKm.clamp(1.0, 500.0);
}