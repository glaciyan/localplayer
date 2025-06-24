import 'dart:convert';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/core/network/api_client.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/spotify_repository.dart';
import 'package:localplayer/features/match/domain/repositories/match_repository.dart';


class MatchRepositoryImpl implements MatchRepository {
  final ApiClient apiClient;
  final ISpotifyRepository spotifyRepository;

  MatchRepositoryImpl({
    required this.apiClient,
    required this.spotifyRepository,
  });

  @override
  Future<List<UserProfile>> fetchProfiles() async {
    try {
      final response = await apiClient.get('/swipe/candidates');
      final List<dynamic> data = response.data;

      return data.map((json) => UserProfile.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch profiles: $e');
    }
  }

  @override
  Future<void> like(UserProfile user) async {
    try {
      await apiClient.post('/swipe/good/${user.handle}');
    } catch (e) {
      throw Exception('Failed to like user: $e');
    }
  }

  @override
  Future<void> dislike(UserProfile user) async {
    try {
      await apiClient.post('/swipe/bad/${user.handle}');
    } catch (e) {
      throw Exception('Failed to dislike user: $e');
    }
  }
}
