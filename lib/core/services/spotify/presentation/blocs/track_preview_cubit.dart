import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/track_entity.dart';
import  'package:localplayer/core/services/spotify/domain/usecases/get_track_use_case.dart';
class TrackPreviewState {
  final TrackEntity? track;
  final bool loading;
  final String? error;

  TrackPreviewState({this.track, this.loading = false, this.error});
}

class TrackPreviewCubit extends Cubit<TrackPreviewState> {
  final GetTrackUseCase useCase;

  TrackPreviewCubit(this.useCase) : super(TrackPreviewState());

  void loadTrack(final String trackId) async {
    emit(TrackPreviewState(loading: true));
    try {
      final TrackEntity track = await useCase(trackId);
      emit(TrackPreviewState(track: track));
    } catch (e) {
      emit(TrackPreviewState(error: e.toString()));
    }
  }
}
