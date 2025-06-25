import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
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
  }

  @override
  Widget build(final BuildContext context) => BlocBuilder<MatchBloc, MatchState>(
      builder: (final BuildContext context, final MatchState state) => switch (state) {
          final MatchLoading _ => const Center(child: CircularProgressIndicator()),
          final MatchInitial _ => const Center(child: Text('Swipe to find matches!')),
          MatchError(:final String message) => Center(child: Text('Error: $message')),
          MatchLoaded(:final List<ProfileWithSpotify> profiles) => _buildLoadedState(context, profiles),
          _ => const Center(child: Text('No profiles found.')),
        },
      );

  Widget _buildLoadedState(final BuildContext context, final List<ProfileWithSpotify> profiles) {
    if (_currentIndex >= profiles.length) {
      _currentIndex = 0;
    }
    if (profiles.isEmpty) {
      return const Center(child: Text('Out of profiles to rate.'));
    }
    if (kDebugMode) {
      print("Loaded profiles: ${profiles.length}");
    }
    return SafeArea(
      child: _buildCardSwiper(profiles),
    );
  }

  Widget _buildCardSwiper(final List<ProfileWithSpotify> profiles) => CardSwiper(
      controller: _swiperController,
      padding: EdgeInsets.zero,
      numberOfCardsDisplayed: 1,
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
          return Positioned.fill(
                child: Text("No more profiels")
              );
        }
        final ProfileWithSpotify profile = profiles[index];
        return BlocProvider<SpotifyProfileCubit>.value(
          value: context.read<SpotifyProfileCubit>(),
          child: Stack(
            children: <Widget> [
              Positioned.fill(
                child: ProfileCard(profile: profile),
              ),
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: _buildSwipeButtons(context, profiles),
              ),
            ],
          ),
        );
      },
      onSwipe: (final int? previousIndex, final int? currentIndex, final CardSwiperDirection direction) {
        if (currentIndex == null || currentIndex >= profiles.length) return true;
        setState(() => _currentIndex = currentIndex);
        final ProfileWithSpotify profile = profiles[currentIndex];
        switch (direction) {
          case CardSwiperDirection.right:
            _matchController.like(profile);
            break;
          case CardSwiperDirection.left:
            _matchController.dislike(profile);
            break;
          default:
            break;
        }
        // if (_currentIndex >= profiles.length - 1) {
        //   _matchController.loadProfiles();
        // }
        return true;
      },
    );


  Widget _buildSwipeButtons(final BuildContext context, final List<ProfileWithSpotify> profiles) {
    void handleSwipe(final CardSwiperDirection direction) {
      if (_currentIndex >= profiles.length) return;
      _swiperController.swipe(direction);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
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
              child: Center(
                child: Iconify(
                  icon,
                  size: 36,
                  color: color,
                ),
              ),
            ),
          ),
        );
  }