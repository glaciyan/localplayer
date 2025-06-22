// lib/features/map/data/repositories/map_repository.dart
import 'package:localplayer/features/feed/data/IFeedRepository.dart';
import 'package:localplayer/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:localplayer/features/feed/domain/models/NotificationModel.dart';

class FeedRepository implements IFeedRepository {
  final ApiClient apiClient;
  FeedRepository(this.apiClient);

  Future<List<NotificationModel>> fetchFeedPosts() async {
    final Response<dynamic> response = await apiClient.get('/feed/posts');
    return ((response.data as Map<String, dynamic>)['posts'] as List<dynamic>)
        .map((final dynamic json) => NotificationModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}