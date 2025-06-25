// lib/features/map/data/repositories/map_repository.dart
import 'package:localplayer/features/feed/data/feed_repository_interface.dart';
import 'package:localplayer/features/feed/domain/models/NotificationModel.dart';
import 'package:localplayer/features/feed/data/datasources/feed_remote_data_source.dart';
import 'package:dio/dio.dart';

// FeedRepository - uses data source + business logic
class FeedRepository implements IFeedRepository {
  final FeedRemoteDataSource _dataSource;
  
  FeedRepository(this._dataSource);

  @override
  Future<List<NotificationModel>> fetchNotifications() async {
    final List<dynamic> rawData = await _dataSource.fetchNotifications();
    List<NotificationModel> notifications = <NotificationModel>[];
    try {
      notifications = (rawData).map((final dynamic json) => NotificationModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return <NotificationModel>[];
    }
    return notifications;
  }

  @override
  Future<bool> acceptSession(final int userId, final int sessionId) async {
    final Response<dynamic> response = await _dataSource.acceptSession(userId, sessionId);
    return response.statusCode == 200;
  }

  @override
  Future<bool> rejectSession(final int userId, final int sessionId) async {
    final Response<dynamic> response = await _dataSource.rejectSession(userId, sessionId);
    return response.statusCode == 200;
  }

  @override
  Future<void> pingUser(final int userId) async {
    await _dataSource.pingUser(userId);
  }
}