import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:latlong2/latlong.dart';
import 'map_event.dart';
import 'map_state.dart';
import 'package:localplayer/features/map/data/datasources/map_remote_data_source.dart';
import 'package:localplayer/core/domain/models/profile.dart';


class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRemoteDataSource mapRemoteDataSource;
  final List<Profile> people;

  MapBloc(this.mapRemoteDataSource, this.people) : super(MapInitial()) {
    
    on<InitializeMap>((final MapEvent event,final Emitter<MapState> emit) {
      final double initLatitude = 37.7749;
      final double initLongitude = -122.4194;
      final double initZoom = 12;
      final List<Profile> people = <Profile> [];

      final LatLng sw = LatLng(initLatitude - 0.01, initLongitude - 0.01);
      final LatLng ne = LatLng(initLatitude + 0.01, initLongitude + 0.01);
      final flutter_map.LatLngBounds bounds = flutter_map.LatLngBounds(sw, ne);

      emit(MapReady(
        latitude: initLatitude, 
        longitude:initLongitude,
        visiblePeople:people,
        visibleBounds: bounds,
        zoom: initZoom
        )); // Default location
    });

    on<UpdateCameraPosition>((final UpdateCameraPosition event,final Emitter<MapState> emit) {
      final flutter_map.LatLngBounds expandedBounds = flutter_map.LatLngBounds(
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
      final List<Profile> visiblePeople = people.where((final Profile person) {
        final LatLng pos = person.position;
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

    on<SelectPlayer>((final SelectPlayer event,final Emitter<MapState> emit) {
      emit(MapProfileSelected(
        latitude: event.selectedPerson.position.latitude,
        longitude: event.selectedPerson.position.longitude,
        visibleBounds: flutter_map. LatLngBounds(
          LatLng(event.selectedPerson.position.latitude - 0.01, event.selectedPerson.position.longitude - 0.01),
          LatLng(event.selectedPerson.position.latitude + 0.01, event.selectedPerson.position.longitude + 0.01)
        ),
        visiblePeople: event.visiblePeople,
        zoom: 12,
        selectedPerson: event.selectedPerson
            ));
    });

    on<DeselectPlayer>((final DeselectPlayer event, final Emitter<MapState> emit) {
      emit(MapReady(
        latitude: event.selectedPerson.position.latitude,
        longitude: event.selectedPerson.position.longitude,
        visiblePeople: people,
        visibleBounds: flutter_map.LatLngBounds(
          LatLng(event.selectedPerson.position.latitude - 0.01, event.selectedPerson.position.longitude - 0.01),
          LatLng(event.selectedPerson.position.latitude + 0.01, event.selectedPerson.position.longitude + 0.01)
        ),
        zoom: 12
        ));
    });

    on<RequestJoinSession>((final RequestJoinSession event, final Emitter<MapState> emit) {
      emit(MapProfileSelected(
        latitude: event.selectedPerson.position.latitude,
        longitude: event.selectedPerson.position.longitude,
        visiblePeople: people,
        visibleBounds: flutter_map.LatLngBounds(
          LatLng(event.selectedPerson.position.latitude - 0.01, event.selectedPerson.position.longitude - 0.01),
          LatLng(event.selectedPerson.position.latitude + 0.01, event.selectedPerson.position.longitude + 0.01)
        ),
        zoom: 12,
        selectedPerson: event.selectedPerson
      ));
    });
  }
}