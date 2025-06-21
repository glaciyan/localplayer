import 'package:localplayer/core/network/api_client.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_state.dart';
import 'package:dio/dio.dart';

class FeedRemoteDataSource {
  final ApiClient apiClient;
  
  FeedRemoteDataSource(this.apiClient);

  Future<List<FeedPost>> fetchFeedPosts() async {
    final Response<dynamic> response = await apiClient.get('/feed/posts');
    
    return ((response.data as Map<String, dynamic>)['posts'] as List<dynamic>)
        .map((final dynamic json) => FeedPost.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<FeedPost>> fetchMorePosts() async {
    final Response<dynamic> response = await apiClient.get('/feed/posts/more');
    
    return ((response.data as Map<String, dynamic>)['posts'] as List<dynamic>)
        .map((final dynamic json) => FeedPost.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> likePost(final String postId) async {
    await apiClient.post('/feed/posts/$postId/like');
  }

  Future<void> unlikePost(final String postId) async {
    await apiClient.delete('/feed/posts/$postId/like');
  }
}