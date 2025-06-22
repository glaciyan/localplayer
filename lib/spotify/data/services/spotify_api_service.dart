import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localplayer/spotify/data/models/track_model.dart';
import 'package:localplayer/spotify/domain/entities/track_entity.dart';

class SpotifyApiService {
  final String clientId;
  final String clientSecret;
  String? _accessToken;

  SpotifyApiService({required this.clientId, required this.clientSecret});

  Future<String> _getAccessToken() async {
    if (_accessToken != null) return _accessToken!;
    final credentials = base64Encode(utf8.encode('$clientId:$clientSecret'));
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access_token'];
      return _accessToken!;
    } else {
      throw Exception('Token error: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> fetchTrack(String trackId) async {
    final token = await _getAccessToken();
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/tracks/$trackId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Track fetch error: ${response.body}');
    }
  }
    Future<List<TrackEntity>> getArtistTopTracks(String artistId) async {
      final token = await _getAccessToken();
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/artists/$artistId/top-tracks?market=US'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final List<dynamic> tracksJson = json['tracks'];
        return tracksJson.map((trackJson) => TrackModel.fromJson(trackJson)).toList();
      } else {
        throw Exception('Failed to load top tracks: ${response.body}');
      }
    }

    Future<Map<String, dynamic>> getArtist(String artistId) async {
    final token = await _getAccessToken();
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/artists/$artistId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Artist fetch error: ${response.body}');
    }
  }
}
