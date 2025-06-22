import '../entities/track_entity.dart';
import '../repositories/track_repository.dart';

class GetTrackUseCase {
  final ITrackRepository repository;

  GetTrackUseCase(this.repository);

  Future<TrackEntity> call(final String trackId)=> repository.getTrackById(trackId);
}
