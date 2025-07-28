import 'package:geolocator/geolocator.dart';

abstract class IGeolocatorService {
  Future<Position> getCurrentLocation();
}