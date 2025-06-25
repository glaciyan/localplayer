import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/core/network/api_client.dart';
import 'package:dio/dio.dart';

class ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSource(this.apiClient);

  Future<UserProfile> fetchCurrentUserProfile() async {
    final Response<dynamic> response = await apiClient.get('/profile/me');
    return UserProfile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> updateUserProfile(final String name, final String biography, final String spotifyId) async {
    final Map<String, dynamic> body = <String, dynamic>{
      'displayName': name,
      'spotifyLink': spotifyId,
      'biography': biography,
    };
    await apiClient.patch('/profile/me', data: body);
  }

  Future<void> signOut() async {
    await apiClient.post('/auth/logout');
  }
}
