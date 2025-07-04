import 'package:localplayer/core/services/spotify/data/models/track_model.dart';
import 'package:localplayer/core/services/spotify/data/services/spotify_api_service.dart';
import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/track_repository.dart';

class TrackRepositoryImpl implements ITrackRepository {
  final SpotifyApiService apiService;

  TrackRepositoryImpl(this.apiService);

  @override
  Future<TrackEntity> getTrackById(final String trackId) async {
    final Map<String, dynamic> json = await apiService.fetchTrack(trackId);
    return TrackModel.fromJson(json);
  }
}
