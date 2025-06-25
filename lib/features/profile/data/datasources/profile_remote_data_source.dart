import 'package:localplayer/core/network/api_client.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:dio/dio.dart';

class ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSource(this.apiClient);

  Future<UserProfile> fetchCurrentUserProfile() async {
    final Response<dynamic> response = await apiClient.get('/profile/me');
    return UserProfile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    final Map<String, dynamic> body = <String, dynamic>{
      'description': profile.biography,
      'avatarLink': profile.avatarLink,
      'backgroundLink': profile.backgroundLink,
      'location': profile.location,
    };
    await apiClient.patch('/profile/me', data: body);
  }
}
