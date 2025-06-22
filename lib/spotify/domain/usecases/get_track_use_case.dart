import '../entities/track_entity.dart';
import '../repositories/track_repository.dart';

class GetTrackUseCase {
  final ITrackRepository repository;

  GetTrackUseCase(this.repository);

  Future<TrackEntity> call(String trackId) {
    return repository.getTrackById(trackId);
  }
}