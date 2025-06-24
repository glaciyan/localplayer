import 'package:colorful_iconify_flutter/icons/logos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';
import 'package:localplayer/core/services/spotify/presentation/widgets/spotfiy_preview_player.dart';
import 'package:url_launcher/url_launcher.dart';

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
                SpotifyPreviewPlayer(trackId: widget.track.id),

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
          ],
        ),
      ),
    );
}
