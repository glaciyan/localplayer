import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:latlong2/latlong.dart';
import 'map_event.dart';
import 'map_state.dart';
import 'package:flutter/material.dart';


class MapBloc extends Bloc<MapEvent, MapState> {

  final List<Map<String, dynamic>> people = [
    {
      'name': 'Alice',
      'position': LatLng(51.509364, -0.128928), // London center
      'avatar': 'https://i1.sndcdn.com/avatars-000614099139-aooibr-t200x200.jpg',
      'color': Colors.orange,
    },
    {
      'name': 'Bob',
      'position': LatLng(51.519364, -0.118928),
      'avatar': 'https://i1.sndcdn.com/avatars-000701366305-hu9f0i-t120x120.jpg',
      'color': Colors.green,
    },];


  MapBloc() : super(MapInitial()) {
    on<InitializeMap>((event, emit) {
      double initLatitude = 37.7749;
      double initLongitude = -122.4194;

      final sw = LatLng(initLatitude - 0.01, initLongitude - 0.01);
      final ne = LatLng(initLatitude + 0.01, initLongitude + 0.01);
      final bounds = flutter_map.LatLngBounds(sw, ne);

      emit(MapReady(latitude: initLatitude, longitude:initLongitude, visiblePeople:people, visibleBounds: bounds)); // Default location
    });

    on<UpdateCameraPosition>((event, emit) {
      final visiblePeople = people.where((person) {
        final pos = person['position'] as LatLng;
        return event.visibleBounds.contains(pos);
      }).toList();

      emit(MapReady(latitude: event.latitude, longitude: event.longitude, visiblePeople: visiblePeople, visibleBounds: event.visibleBounds));
    });
  }
}