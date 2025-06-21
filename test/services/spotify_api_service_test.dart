// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/core/services/spotify/data/services/spotify_api_service.dart';
import 'package:localplayer/core/services/spotify/data/services/config_service.dart';

void main() {

  group('SpotifyApiService', () {
    
    late ConfigService config;
    late SpotifyApiService service;

    setUp(() async {
      config = ConfigService();
      await config.load();
      service = SpotifyApiService(
        clientId: config.clientId,
        clientSecret: config.clientSecret,
      );
    });

    test('should fetch track by ID', () async {
      final String trackId = '1n8wr8tRHs5jmBxNWXedcn';
      
      final Map<String, dynamic> result = await service.fetchTrack(trackId);
      
      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], equals(trackId));
      expect(result['name'], isNotEmpty);
      expect(result['artists'], isNotEmpty);
    });

    test('should fetch artist profile picture', () async {
      // Test mit einer bekannten Artist ID
      final String artistId = '1n8wr8tRHs5jmBxNWXedcn'; // Ed Sheeran
      
      final List<dynamic> result = await service.fetchArtistProfilePicture(artistId);
      
      expect(result, isA<List<dynamic>>());
      expect(result.isNotEmpty, isTrue);
    });

    test('should fetch top tracks for artist', () async {
      final String artistId = '1n8wr8tRHs5jmBxNWXedcn'; // Ed Sheeran
      
      final Map<String, dynamic> result = await service.fetchTopTracks(artistId);
      
      expect(result, isA<Map<String, dynamic>>());
      expect(result['tracks'], isA<List<dynamic>>());
    });
  });
}
