import 'package:localplayer/core/network/api_client.dart';
import 'package:dio/dio.dart';

class FeedRemoteDataSource {
  final ApiClient apiClient;
  
  FeedRemoteDataSource(this.apiClient);

  Future<List<dynamic>> fetchNotifications() async {
    final Response<dynamic> response = await apiClient.get('/notification/');
    return response.data as List<dynamic>;
  }

  Future<List<dynamic>> pingUser(final int userId) async {
    final Response<dynamic> response = await apiClient.post('/ping/$userId');
    return response.data as List<dynamic>;
  }

  Future<Response<dynamic>> acceptSession(final int userId, final int sessionId) async {    
    final Response<dynamic> response = await apiClient.post(
      '/session/requests/respond',
      data: <String, dynamic> {'participantId': userId, 'sessionId': sessionId, 'accept': true},
    );
    return response;
  }

  Future<Response<dynamic>> rejectSession(final int userId, final int sessionId) async {
    final Response<dynamic> response = await apiClient.post(
      '/session/requests/respond', 
      data: <String, dynamic> {'participantId': userId, 'sessionId': sessionId, 'accept': false},
    );
    return response;
  }
}