import '../../domain/repositories/track_repository.dart';
import '../../domain/entities/track_entity.dart';
import 'package:localplayer/spotify/data/services/spotify_api_service.dart';
import 'package:localplayer/spotify/data/models/track_model.dart';

class TrackRepositoryImpl implements ITrackRepository {
  final SpotifyApiService apiService;

  TrackRepositoryImpl(this.apiService);

  @override
  Future<TrackEntity> getTrackById(final String trackId) async {
    final Map<String, dynamic> json = await apiService.fetchTrack(trackId);
    return TrackModel.fromJson(json);
  }
}
