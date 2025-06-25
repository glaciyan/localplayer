import 'package:localplayer/core/network/api_client.dart';
import 'package:dio/dio.dart';

class FeedRemoteDataSource {
  final ApiClient apiClient;
  
  FeedRemoteDataSource(this.apiClient);

  Future<List<dynamic>> fetchNotifications() async {
    final Response<dynamic> response = await apiClient.get('/notification/');
    return response.data as List<dynamic>;
  }

  Future<void> acceptSession(final String sessionId, final String userId) async {
    await apiClient.post(
      '/session/requests/respond', 
      data: <String, dynamic> {'participantId': userId, 'sessionId': sessionId, 'accept': true},
    );
  }

  Future<void> rejectSession(final String sessionId, final String userId) async {
    await apiClient.post(
      '/session/requests/respond', 
      data: <String, dynamic> {'participantId': userId, 'sessionId': sessionId, 'accept': false},
    );
  }
}