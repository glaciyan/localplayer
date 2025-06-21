// lib/features/map/data/repositories/map_repository.dart
import 'package:localplayer/features/feed/data/IFeedRepository.dart';
import 'package:localplayer/core/network/api_client.dart';


class FeedRepository implements IFeedRepository {
  final ApiClient apiClient;
  FeedRepository(this.apiClient);
  
}