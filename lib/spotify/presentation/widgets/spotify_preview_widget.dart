import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:colorful_iconify_flutter/icons/logos.dart';
import 'package:localplayer/spotify/domain/entities/track_entity.dart';
import 'package:flutter/foundation.dart';


class SpotifyPreviewWidget extends StatefulWidget {
  final TrackEntity track;

  const SpotifyPreviewWidget({super.key, required this.track});

  @override
  State<SpotifyPreviewWidget> createState() => _SpotifyPreviewWidgetState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TrackEntity>('track', track));
  }
}

class _SpotifyPreviewWidgetState extends State<SpotifyPreviewWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;

  String? get previewUrl => widget.track.previewUrl;

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<String?>('previewUrl', previewUrl));
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (previewUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No preview available for this track.")),
        );
        return;
      }

      setState(() => _isLoading = true);
      try {
        await _audioPlayer.setUrl(previewUrl!);
        await _audioPlayer.play();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
      setState(() => _isLoading = false);
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Card(
      color: const Color.fromRGBO(18, 18, 18, 1),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: const Color.fromRGBO(30, 215, 69, 1),
                    size: 32,
                  ),
                  onPressed: _isLoading ? null : _togglePlay,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.track.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: const Color.fromRGBO(164, 165, 164, 1),
                            ),
                      ),
                      Text(
                        widget.track.artist,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: const Color.fromRGBO(164, 165, 164, 1),
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Iconify(Logos.spotify),
                  onPressed: () async {
                    final String url = "https://open.spotify.com/track/${widget.track.id}";
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    }
                  },
                ),
              ],
            ),
            if (_isLoading) const LinearProgressIndicator(),
          ],
        ),
      ),
    );
}