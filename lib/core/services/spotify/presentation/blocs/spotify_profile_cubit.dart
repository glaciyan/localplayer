import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/spotify_repository.dart';
import 'package:localplayer/core/services/spotify/presentation/blocs/spotify_profile_state.dart';

class SpotifyProfileCubit extends Cubit<SpotifyProfileState> {
  final ISpotifyRepository repository;

  SpotifyProfileCubit(this.repository) : super(SpotifyProfileState.initial());

  Future<void> loadProfile(final String spotifyId) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final SpotifyArtistData data = await repository.fetchArtistData(spotifyId);
      emit(state.copyWith(loading: false, artist: data));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
