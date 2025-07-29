import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/services/spotify/data/services/spotify_audio_service.dart';
import 'package:localplayer/core/services/spotify/presentation/blocs/spotify_profile_cubit.dart';
import 'package:localplayer/core/widgets/profile_card.dart';
import 'package:localplayer/features/match/domain/interfaces/match_controller_interface.dart';
import 'package:localplayer/features/match/match_module.dart';
import 'package:localplayer/features/match/presentation/blocs/match_bloc.dart';
import 'package:localplayer/features/match/presentation/blocs/match_state.dart';

class MatchWidget extends StatefulWidget {
  const MatchWidget({super.key});

  @override
  State<MatchWidget> createState() => _MatchWidgetState();
}

class _MatchWidgetState extends State<MatchWidget> {
  late final CardSwiperController _swiperController;
  late final IMatchController _matchController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _swiperController = CardSwiperController();
    final MatchBloc bloc = context.read<MatchBloc>();
    _matchController = MatchModule.provideController(context, bloc);
    _matchController.loadProfiles();
  }
  @override
  void dispose() {
    SpotifyAudioService().stop();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) =>
      BlocListener<MatchBloc, MatchState>(
        listener: (final BuildContext context, final MatchState state) {
          if (state is ToastedMatchError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<MatchBloc, MatchState>(
          builder:
              (final BuildContext context, final MatchState state) =>
                  switch (state) {
                    final MatchLoading _ => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    final MatchInitial _ => const Center(
                      child: Text('Swipe to find matches!'),
                    ),
                    MatchError(:final String message) => Center(
                      child: Text(
                        message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    MatchLoaded(:final List<ProfileWithSpotify> profiles) =>
                      _buildLoadedState(context, profiles),
                    _ => const Center(child: Text('No profiles found.', style: TextStyle(color: Colors.black),)),
                  },
        ),
      );

  Widget _buildLoadedState(
    final BuildContext context,
    final List<ProfileWithSpotify> profiles,
  ) {
    if (_currentIndex >= profiles.length) {
      _currentIndex = 0;
    }
    if (profiles.isEmpty) {
      return _buildNoMoreProfilesMessage(context);
    }
    return SafeArea(
      child: _buildCardSwiper(profiles),
    );
  }

  Widget _buildCardSwiper(final List<ProfileWithSpotify> profiles) => CardSwiper(
      controller: _swiperController,
      padding: EdgeInsets.zero,
      numberOfCardsDisplayed: 2,
      backCardOffset: const Offset(0, 20),
      maxAngle: 30,
      threshold: 60,
      isLoop: false,
      allowedSwipeDirection: const AllowedSwipeDirection.symmetric(
        horizontal: true,
        vertical: false,
      ),
      cardsCount: profiles.length + 1,
      cardBuilder: (final BuildContext context, final int index, final int percentX, final int percentY) {
        if (index == profiles.length) {
          return _buildNoMoreProfilesMessage(context);
        }
        final ProfileWithSpotify profile = profiles[index];
        return BlocProvider<SpotifyProfileCubit>.value(
          value: context.read<SpotifyProfileCubit>(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: ProfileCard(profile: profile),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 180,
                  child: IgnorePointer(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: <Color>[Colors.black, Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Center(
                      child: _buildSwipeButtons(context, profiles),
                    ),
                  ),
                ),
              ],
            ),
          ),

        );
      },
      onSwipe: (final int? previousIndex, final int? currentIndex, final CardSwiperDirection direction) {
        SpotifyAudioService().stop();

          if (previousIndex == null || previousIndex >= profiles.length) {
            return true;
          }

          final ProfileWithSpotify swipedProfile = profiles[previousIndex];
          switch (direction) {
            case CardSwiperDirection.right:
              _matchController.like(swipedProfile);
              break;
            case CardSwiperDirection.left:
              _matchController.dislike(swipedProfile);
              break;
            default:
              break;
          }

          if (currentIndex != null && currentIndex < profiles.length) {
            setState(() => _currentIndex = currentIndex);
          } else {
            setState(() => _currentIndex = profiles.length);
          }

          return true;
        },
      );

  Widget _buildNoMoreProfilesMessage(final BuildContext context) => Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'No more profiles',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );

  Widget _buildSwipeButtons(
    final BuildContext context,
    final List<ProfileWithSpotify> profiles,
  ) {
    void handleSwipe(final CardSwiperDirection direction) {
      if (_currentIndex >= profiles.length) return;
      _swiperController.swipe(direction);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildSwipeButton(
          icon: IconParkSolid.dislike_two,
          color: Theme.of(context).highlightColor,
          onPressed: () => handleSwipe(CardSwiperDirection.left),
        ),
        const SizedBox(width: 20),
        _buildSwipeButton(
          icon: IconParkSolid.like,
          color: Theme.of(context).highlightColor,
          onPressed: () => handleSwipe(CardSwiperDirection.right),
        ),
      ],
    );
  }

  Widget _buildSwipeButton({
    required final String icon,
    required final Color color,
    required final VoidCallback onPressed,
  }) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Center(child: Iconify(icon, size: 36, color: color)),
      ),
    ),
  );
}
