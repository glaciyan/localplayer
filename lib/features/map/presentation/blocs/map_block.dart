// features/map/presentation/blocs/map/map_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
// separete events and states into their own files when they grow larger
abstract class MapEvent {}

abstract class MapState {}

class MapInitial extends MapState {}

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial());
}
