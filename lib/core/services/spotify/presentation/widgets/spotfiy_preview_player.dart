import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/services/spotify/data/services/spotify_audio_service.dart';
import 'package:localplayer/core/services/spotify/presentation/blocs/spotify_preview_cubit.dart';
import 'package:localplayer/core/services/spotify/presentation/blocs/sptofiy_preview_state.dart';
import 'package:flutter/foundation.dart';

class SpotifyPreviewPlayer extends StatefulWidget {
  final String trackId;

  const SpotifyPreviewPlayer({super.key, required this.trackId});

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('trackId', trackId));
  }

  @override
  State<SpotifyPreviewPlayer> createState() => _SpotifyPreviewPlayerState();
}

class _SpotifyPreviewPlayerState extends State<SpotifyPreviewPlayer> {
  final SpotifyAudioService _audioService = SpotifyAudioService();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioService.setOnComplete(() {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  void _stopThisPlayer() {
    if (mounted) setState(() => _isPlaying = false);
  }

  Future<void> _startPlayback(final String filePath) async {
    try {
      await _audioService.play(filePath, widget.trackId, _stopThisPlayer);
      if (mounted) setState(() => _isPlaying = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Playback failed: $e")),
        );
      }
    }
  }

  @override
  Widget build(final BuildContext context) => BlocConsumer<SpotifyPreviewCubit, SpotifyPreviewState>(
      listener: (final BuildContext context, final SpotifyPreviewState state) {
        if (state is SpotifyPreviewLoaded) {
          _startPlayback(state.filePath);
        }
      },
      builder: (final BuildContext context, final SpotifyPreviewState state) {
        if (state is SpotifyPreviewLoading) {
          return const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }

        return IconButton(
          icon: Icon(
            _isPlaying ? Icons.pause : Icons.play_arrow,
            color: const Color.fromRGBO(30, 215, 69, 1),
            size: 32,
          ),
          onPressed: () {
            if (_isPlaying) {
              _audioService.pause();
              setState(() => _isPlaying = false);
            } else {
              context.read<SpotifyPreviewCubit>().loadAndPlayPreview(widget.trackId);
            }
          },
        );
      },
    );
}
