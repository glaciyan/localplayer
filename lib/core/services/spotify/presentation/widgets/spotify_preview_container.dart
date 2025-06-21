
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/services/spotify/presentation/blocs/track_preview_cubit.dart';
import 'package:localplayer/core/services/spotify/domain/usecases/get_track_use_case.dart';
import 'package:localplayer/core/services/spotify/presentation/widgets/spotify_preview_widget.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/track_repository.dart';

class SpotifyPreviewContainer extends StatelessWidget {
  final String trackId;

  const SpotifyPreviewContainer({super.key, required this.trackId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repository = RepositoryProvider.of<ITrackRepository>(context);
        return TrackPreviewCubit(GetTrackUseCase(repository))..loadTrack(trackId);
      },
      child: BlocBuilder<TrackPreviewCubit, TrackPreviewState>(
        builder: (context, state) {
          if (state.loading) return CircularProgressIndicator();
          if (state.error != null) return Text("Error: ${state.error}");
          if (state.track != null) {
            return SpotifyPreviewWidget(track: state.track!);
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
