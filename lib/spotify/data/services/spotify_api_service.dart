import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:localplayer/spotify/data/models/track_model.dart';
import 'package:localplayer/spotify/domain/entities/track_entity.dart';

class SpotifyApiService {
  final String clientId;
  final String clientSecret;
  String? _accessToken;

  SpotifyApiService({required this.clientId, required this.clientSecret});

  Future<String> _getAccessToken() async {
    if (_accessToken != null) return _accessToken!;
    final String credentials = base64Encode(utf8.encode('$clientId:$clientSecret'));
    final Response response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: <String, String> {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String> {
        'grant_type': 'client_credentials',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      _accessToken = data['access_token'];
      return _accessToken!;
    } else {
      throw Exception('Token error: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> fetchTrack(final String trackId) async {
    final String token = await _getAccessToken();
    final Response response = await http.get(
      Uri.parse('https://api.spotify.com/v1/tracks/$trackId'),
      headers: <String, String> {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Track fetch error: ${response.body}');
    }
  }
    Future<List<TrackEntity>> getArtistTopTracks(final String artistId) async {
      final String token = await _getAccessToken();
      final Response response = await http.get(
        Uri.parse('https://api.spotify.com/v1/artists/$artistId/top-tracks?market=US'),
        headers: <String, String> {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body) as Map<String, dynamic>;
        final List<dynamic> tracksJson = json['tracks'];
        return tracksJson.map((final dynamic trackJson) => TrackModel.fromJson(trackJson)).toList();
      } else {
        throw Exception('Failed to load top tracks: ${response.body}');
      }
    }

    Future<Map<String, dynamic>> getArtist(final String artistId) async {
    final String token = await _getAccessToken();
    final Response response = await http.get(
      Uri.parse('https://api.spotify.com/v1/artists/$artistId'),
      headers: <String, String> {
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
