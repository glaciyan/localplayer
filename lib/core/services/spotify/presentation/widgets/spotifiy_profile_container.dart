// lib/presentation/widgets/spotify/spotify_profile_container.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/spotify/domain/entities/spotify_artist_data.dart';
import 'package:localplayer/spotify/domain/repositories/spotify_repository.dart';
import 'package:localplayer/spotify/presentation/blocs/spotify_profiel_cubit.dart';
import 'package:localplayer/spotify/presentation/blocs/spotify_profile_state.dart';

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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repository = RepositoryProvider.of<ISpotifyRepository>(context);
        final cubit = SpotifyProfileCubit(repository);
        cubit.loadProfile(spotifyId);

        if (preloadNextId != null) {
          cubit.loadProfile(preloadNextId!);
        }

        return cubit;
      },
      child: BlocBuilder<SpotifyProfileCubit, SpotifyProfileState>(
        builder: (context, state) {
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
}

