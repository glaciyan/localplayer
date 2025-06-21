import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:latlong2/latlong.dart';
import 'map_event.dart';
import 'map_state.dart';
import 'package:flutter/material.dart';



class MapBloc extends Bloc<MapEvent, MapState> {

  final List<Map<String, dynamic>> people = [
    {
      'id': 1,
      'name': 'Travis',
      'position': LatLng(51.5155, -0.1421), // Soho / Fitzrovia
      'avatar': 'https://i1.sndcdn.com/avatars-000614099139-aooibr-t200x200.jpg',
      'color': Colors.orange,
      'listeners': 200000,
    },
    {
      'id': 1,
      'name': 'Caye',
      'position': LatLng(51.5300, -0.1230), // Camden
      'avatar': 'https://i1.sndcdn.com/avatars-000701366305-hu9f0i-t120x120.jpg',
      'color': Colors.green,
      'listeners': 40000,
    },
    {
      'id': 1,
      'name': 'Prayne',
      'position': LatLng(51.4750, -0.2050), // Hammersmith
      'avatar': 'https://i1.sndcdn.com/avatars-hqOFChrylqxxfERP-y7l2xg-t500x500.jpg',
      'color': Colors.orange,
      'listeners': 400550,
    },
    {
      'id': 1,
      'name': 'Ski',
      'position': LatLng(51.4600, -0.1150), // Brixton
      'avatar': 'https://i1.sndcdn.com/avatars-LdxjRhrIRcy3D2uY-RaxmNw-t500x500.jpg',
      'color': Colors.green,
      'listeners': 2193809,
    },
    {
      'id': 1,
      'name': 'Trip',
      'position': LatLng(51.4300, -0.1500), // Clapham
      'avatar': 'https://i1.sndcdn.com/avatars-000452119941-gi041q-t500x500.jpg',
      'color': Colors.orange,
      'listeners': 12123124,
    },
    {
      'id': 1,
      'name': 'caye',
      'position': LatLng(51.4800, -0.0014), // Greenwich
      'avatar': 'https://i1.sndcdn.com/avatars-h506nrS9VS2UeYd6-ipLOlQ-t500x500.jpg',
      'color': Colors.green,
      'listeners': 21312,
    },
    {
      'id': 1,
      'name': 'sol',
      'position': LatLng(51.4600, -0.3000), // Richmond
      'avatar': 'https://i1.sndcdn.com/avatars-IzVpz6VYWsyEg3af-kIOmow-t500x500.jpg',
      'color': Colors.orange,
      'listeners': 2193083,
    },
    {
      'id': 1,
      'name': 'Bob',
      'position': LatLng(51.3700, -0.1000), // Croydon
      'avatar': 'https://i1.sndcdn.com/avatars-000701366305-hu9f0i-t120x120.jpg',
      'color': Colors.green,
      'listeners': 21903,
    }
  ];

  MapBloc() : super(MapInitial()) {
    
    on<InitializeMap>((event, emit) {
      double initLatitude = 37.7749;
      double initLongitude = -122.4194;
      double initZoom = 12;

      final sw = LatLng(initLatitude - 0.01, initLongitude - 0.01);
      final ne = LatLng(initLatitude + 0.01, initLongitude + 0.01);
      final bounds = flutter_map.LatLngBounds(sw, ne);

      emit(MapReady(
        latitude: initLatitude, 
        longitude:initLongitude,
        visiblePeople:people,
        visibleBounds: bounds,
        zoom: initZoom
        )); // Default location
    });

    on<UpdateCameraPosition>((event, emit) {
      final expandedBounds = flutter_map.LatLngBounds(
        LatLng(
          event.visibleBounds.southWest.latitude - 0.05, // Add ~5.5km south
          event.visibleBounds.southWest.longitude - 0.05, // Add ~5.5km west
        ),
        LatLng(
          event.visibleBounds.northEast.latitude + 0.05, // Add ~5.5km north
          event.visibleBounds.northEast.longitude + 0.05, // Add ~5.5km east
        ),
      );

      // Filter people for the expanded bounds instead of just visible bounds
      final visiblePeople = people.where((person) {
        final pos = person['position'] as LatLng;
        return expandedBounds.contains(pos); // Use expanded bounds
      }).toList();

      emit(MapReady(
        latitude: event.latitude, 
        longitude: event.longitude,
        visiblePeople: visiblePeople,
        visibleBounds: expandedBounds, // Use expanded bounds
        zoom: event.zoom
      ));
    });

    on<SelectPlayer>((event, emit) {
      emit(MapProfileSelected(
        latitude: event.selectedPerson['position'].latitude,
        longitude: event.selectedPerson['position'].longitude,
        visibleBounds: flutter_map. LatLngBounds(
          LatLng(event.selectedPerson['position'].latitude - 0.01, event.selectedPerson['position'].longitude - 0.01),
          LatLng(event.selectedPerson['position'].latitude + 0.01, event.selectedPerson['position'].longitude + 0.01)
        ),
        visiblePeople: people,
        zoom: 12,
        selectedPerson: event.selectedPerson
            ));
    });

    on<DeselectPlayer>((event, emit) {
      emit(MapReady(
        latitude: event.selectedPerson['position'].latitude,
        longitude: event.selectedPerson['position'].longitude,
        visiblePeople: people,
        visibleBounds: flutter_map.LatLngBounds(
          LatLng(event.selectedPerson['position'].latitude - 0.01, event.selectedPerson['position'].longitude - 0.01),
          LatLng(event.selectedPerson['position'].latitude + 0.01, event.selectedPerson['position'].longitude + 0.01)
        ),
        zoom: 12
        ));
    });

    on<RequestJoinSession>((event, emit) {
      emit(MapProfileSelected(
        latitude: event.selectedPerson['position'].latitude,
        longitude: event.selectedPerson['position'].longitude,
        visiblePeople: people,
        visibleBounds: flutter_map.LatLngBounds(
          LatLng(event.selectedPerson['position'].latitude - 0.01, event.selectedPerson['position'].longitude - 0.01),
          LatLng(event.selectedPerson['position'].latitude + 0.01, event.selectedPerson['position'].longitude + 0.01)
        ),
        zoom: 12,
        selectedPerson: event.selectedPerson
      ));
    });
  }
}