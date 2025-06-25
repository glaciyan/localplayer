import 'package:localplayer/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:localplayer/core/entities/user_profile.dart';

class MatchRemoteDataSource {
  final ApiClient apiClient;
  
  MatchRemoteDataSource(this.apiClient);

  Future<List<UserProfile>> fetchProfiles(final double latitude, final double longitude, final double radiusKm) async {
    final Response<dynamic> response = await apiClient.get('/swipe/candidates');
    final List<dynamic> rawProfiles = response.data as List<dynamic>? ?? <dynamic>[];

    final List<UserProfile> profiles = <UserProfile> [];
    for (final dynamic entry in rawProfiles) {
      try {
        profiles.add(UserProfile.fromJson(entry as Map<String, dynamic>));
      } catch (_) {
        // Skip malformed entries
      }
    }

    return profiles;
  }

  Future<Map<String, dynamic>> rate(final String rating, final int swipeeId) async {
    final Response<dynamic> response = await apiClient.post('/swipe/$rating/$swipeeId');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> like(final int profileId) async =>
      rate('good', profileId);

  Future<Map<String, dynamic>> dislike(final int profileId) async =>
      rate('bad', profileId);
}