import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotifyPreviewWidget extends StatefulWidget {
  final String trackId; // e.g., "6rqhFgbbKwnb9MLmUQDhG6" (from Spotify URL)

  const SpotifyPreviewWidget({Key? key, required this.trackId}) : super(key: key);

  @override
  State<SpotifyPreviewWidget> createState() => _SpotifyPreviewWidgetState();
}

class _SpotifyPreviewWidgetState extends State<SpotifyPreviewWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;

  String get previewUrl => "https://p.scdn.co/mp3-preview/${widget.trackId}";

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      setState(() => _isLoading = true);
      try {
        await _audioPlayer.setUrl(previewUrl);
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
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 32,
                  ),
                  onPressed: _isLoading ? null : _togglePlay,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Song Preview",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "30-second preview",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.open_in_new),
                  onPressed: () async {
                    final url = "https://open.spotify.com/track/${widget.trackId}";
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    }
                  },
                ),
              ],
            ),
            if (_isLoading) LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}