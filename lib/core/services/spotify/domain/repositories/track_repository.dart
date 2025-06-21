// core/domain/repositories/track_repository.dart
import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';

abstract class ITrackRepository {
  Future<TrackEntity> getTrackById(String trackId);
}