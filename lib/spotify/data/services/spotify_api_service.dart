import 'dart:convert';
import 'package:http/http.dart' as http;

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
}
