// lib/features/map/data/repositories/map_repository.dart
import 'package:localplayer/features/feed/data/feed_repository_interface.dart';
import 'package:localplayer/features/feed/domain/models/NotificationModel.dart';
import 'package:localplayer/features/feed/data/datasources/feed_remote_data_source.dart';

// FeedRepository - uses data source + business logic
class FeedRepository implements IFeedRepository {
  final FeedRemoteDataSource _dataSource;
  
  FeedRepository(this._dataSource);

  @override
  Future<List<NotificationModel>> fetchNotifications() async {
    final List<dynamic> rawData = await _dataSource.fetchNotifications();
    return (rawData)
        .map((final dynamic json) => NotificationModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> acceptSession(final String sessionId, final String userId) async {
    await _dataSource.acceptSession(sessionId, userId);
  }

  @override
  Future<void> rejectSession(final String sessionId, final String userId) async {
    await _dataSource.rejectSession(sessionId, userId);
  }
}