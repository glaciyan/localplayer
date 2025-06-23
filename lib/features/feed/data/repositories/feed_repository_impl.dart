// lib/features/map/data/repositories/map_repository.dart
import 'package:localplayer/features/feed/data/IFeedRepository.dart';
import 'package:localplayer/features/feed/domain/models/NotificationModel.dart';
import 'package:localplayer/features/feed/data/datasources/feed_remote_data_source.dart';

// FeedRepository - uses data source + business logic
class FeedRepository implements IFeedRepository {
  final FeedRemoteDataSource _dataSource;
  
  FeedRepository(this._dataSource);

  @override
  Future<List<NotificationModel>> fetchFeedPosts() async {
    final Map<String, dynamic> rawData = await _dataSource.fetchFeedPosts();
    return (rawData['posts'] as List<dynamic>)
        .map((final dynamic json) => NotificationModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> acceptSession(final String sessionId) async {
    await _dataSource.acceptSession(sessionId);
  }

  @override
  Future<void> rejectSession(final String sessionId) async {
    await _dataSource.rejectSession(sessionId);
  }
}