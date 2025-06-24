import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/services/spotify/data/services/config_service.dart';
import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';
import 'package:localplayer/core/services/spotify/presentation/blocs/spotify_preview_cubit.dart';
import 'package:localplayer/core/services/spotify/presentation/widgets/spotify_preview_widget.dart';
import 'package:localplayer/core/services/spotify/spotify_module.dart';

class SpotifyPreviewContainer extends StatelessWidget {
  final TrackEntity track;

  const SpotifyPreviewContainer({super.key, required this.track});

  @override
  Widget build(final BuildContext context) {
    final ConfigService config = context.read<ConfigService>();

    return BlocProvider<SpotifyPreviewCubit>(
      create: (_) => SpotifyModule.providePreviewCubit(config),
      child: SpotifyPreviewWidget(track: track),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TrackEntity>('track', track));
  }
}
