import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';

class SpotifyAudioService {
  static final SpotifyAudioService _instance = SpotifyAudioService._internal();

  factory SpotifyAudioService() => _instance;

  final AudioPlayer _player = AudioPlayer();
  VoidCallback? _onStopCurrentPlayback;
  String? _currentTrackId;

  SpotifyAudioService._internal();

  Future<void> play(final String filePath, final String trackId, final VoidCallback onStop) async {
    if (_currentTrackId != trackId) {
      _player.stop();
      _onStopCurrentPlayback?.call();
    }

    _currentTrackId = trackId;
    _onStopCurrentPlayback = onStop;

    await _player.setSource(DeviceFileSource(filePath));
    await _player.resume();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  void stop() {
    _player.stop();
    _onStopCurrentPlayback?.call();
    _currentTrackId = null;
    _onStopCurrentPlayback = null;
  }


  void setOnComplete(final VoidCallback onComplete) {
    _player.onPlayerComplete.listen((_) {
      onComplete();
    });
  }

  bool get isPlaying => _player.state == PlayerState.playing;
}
