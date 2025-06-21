import '../../domain/repositories/track_repository.dart';
import '../../domain/entities/track_entity.dart';
import 'package:localplayer/core/services/spotify/data/services/spotify_api_service.dart';
import 'package:localplayer/core/services/spotify/data/models/track_model.dart';

class TrackRepositoryImpl implements ITrackRepository {
  final SpotifyApiService apiService;

  TrackRepositoryImpl(this.apiService);

  @override
  Future<TrackEntity> getTrackById(String trackId) async {
    final json = await apiService.fetchTrack(trackId);
    return TrackModel.fromJson(json);
  }
}
