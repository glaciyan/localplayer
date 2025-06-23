import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/spotify/presentation/blocs/track_preview_cubit.dart';
import 'package:localplayer/spotify/domain/usecases/get_track_use_case.dart';
import 'package:localplayer/spotify/presentation/widgets/spotify_preview_widget.dart';
import 'package:localplayer/spotify/domain/repositories/track_repository.dart';
import 'package:flutter/foundation.dart';

class SpotifyPreviewContainer extends StatelessWidget {
  final String trackId;

  const SpotifyPreviewContainer({super.key, required this.trackId});

  @override
  Widget build(final BuildContext context) => BlocProvider<TrackPreviewCubit>(
      create: (final BuildContext context) {
        final ITrackRepository repository = RepositoryProvider.of<ITrackRepository>(context);
        final TrackPreviewCubit cubit = TrackPreviewCubit(GetTrackUseCase(repository))..loadTrack(trackId);
        return cubit;
      },
      child: BlocBuilder<TrackPreviewCubit, TrackPreviewState>(
        builder: (final BuildContext context, final TrackPreviewState state) {
          if (state.loading) return CircularProgressIndicator();
          if (state.error != null) return Text("Error: ${state.error}");
          if (state.track != null) {
            return SpotifyPreviewWidget(track: state.track!);
          }
          return SizedBox.shrink();
        },
      ),
    );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('trackId', trackId));
  }
}
