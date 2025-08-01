import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/spotify_repository.dart';
import 'package:localplayer/core/services/spotify/presentation/blocs/spotify_profile_cubit.dart';
import 'package:localplayer/core/services/spotify/presentation/blocs/spotify_profile_state.dart';

class SpotifyProfileContainer extends StatelessWidget {
  final String spotifyId;
  final String? preloadNextId;
  final Widget Function(BuildContext context, SpotifyArtistData artist) builder;

  const SpotifyProfileContainer({
    super.key,
    required this.spotifyId,
    required this.builder,
    this.preloadNextId,
  });

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('spotifyId', spotifyId));
    properties.add(StringProperty('preloadNextId', preloadNextId));
    properties.add(ObjectFlagProperty<Widget Function(BuildContext context, SpotifyArtistData artist)>.has('builder', builder));
  }

  @override
  Widget build(final BuildContext context) => BlocProvider<SpotifyProfileCubit>(
      create: (final BuildContext context) {
        final ISpotifyRepository repository = RepositoryProvider.of<ISpotifyRepository>(context);
        final SpotifyProfileCubit cubit = SpotifyProfileCubit(repository);
        cubit.loadProfile(spotifyId);

        if (preloadNextId != null) {
          cubit.loadProfile(preloadNextId!);
        }

        return cubit;
      },
      child: BlocBuilder<SpotifyProfileCubit, SpotifyProfileState>(
        builder: (final BuildContext context, final SpotifyProfileState state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text("Error: ${state.error}"));
          }
          if (state.artist != null) {
            return builder(context, state.artist!);
          }
          return const SizedBox.shrink();
        },
      ),
    );
}

