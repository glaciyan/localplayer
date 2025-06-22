import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/widgets/profile_card.dart';
import 'package:localplayer/features/match/domain/controllers/match_controller_interface.dart';
import 'package:localplayer/features/match/match_module.dart';
import 'package:localplayer/features/match/presentation/blocs/match_block.dart';
import 'package:localplayer/features/match/presentation/blocs/match_event.dart';
import 'package:localplayer/features/match/presentation/blocs/match_state.dart';
import 'package:localplayer/spotify/presentation/blocs/spotify_profiel_cubit.dart';

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
    final bloc = context.read<MatchBloc>();
    _matchController = MatchModule.provideController(context, bloc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchBloc, MatchState>(
      builder: (context, state) {
        return switch (state) {
          MatchLoading => const Center(child: CircularProgressIndicator()),
          MatchInitial => const Center(child: Text('Swipe to find matches!')),
          MatchError(:final message) => Center(child: Text('Error: $message')),
          MatchLoaded(:final profiles) => _buildLoadedState(context, profiles),
          _ => const Center(child: Text('No profiles found.')),
        };
      },
    );
  }

  Widget _buildLoadedState(BuildContext context, List<ProfileWithSpotify> profiles) {
    if (profiles.isEmpty) {
      return const Center(child: Text('No more profiles.'));
    }

    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            bottom: kBottomNavigationBarHeight + 90,
            child: _buildCardSwiper(profiles),
          ),
          Positioned(
            bottom: kBottomNavigationBarHeight + 5,
            left: 0,
            right: 0,
            child: _buildSwipeButtons(context, profiles),
          ),
        ],
      ),
    );
  }


  Widget _buildCardSwiper(List<ProfileWithSpotify> profiles) {
    return CardSwiper(
      controller: _swiperController,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      numberOfCardsDisplayed: 2,
      backCardOffset: const Offset(0, 20),
      maxAngle: 30,
      threshold: 60,
      allowedSwipeDirection: const AllowedSwipeDirection.symmetric(
        horizontal: true,
        vertical: false,
      ),
      cardsCount: profiles.length,
      cardBuilder: (context, index, percentX, percentY) {
        final profile = profiles[index];
        return BlocProvider.value(
          value: context.read<SpotifyProfileCubit>(),
          child: KeyedSubtree(
            key: ValueKey(profile.user.spotifyId),
            child: ProfileCard(profile: profile),
          ),
        );
      },
      onSwipe: (previousIndex, currentIndex, direction) {
        if (currentIndex == null || currentIndex >= profiles.length) return true;
        setState(() => _currentIndex = currentIndex);
        final profile = profiles[currentIndex];
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
        return true;
      },
    );
  }

  Widget _buildSwipeButtons(BuildContext context, List<ProfileWithSpotify> profiles) {
    void handleSwipe(CardSwiperDirection direction) {
      if (_currentIndex >= profiles.length) return;
      final profile = profiles[_currentIndex];

      switch (direction) {
        case CardSwiperDirection.right:
          context.read<MatchBloc>().add(LikePressed(profile.user));
          break;
        case CardSwiperDirection.left:
          context.read<MatchBloc>().add(DislikePressed(profile.user));
          break;
        default:
          return;
      }

      _swiperController.swipe(direction);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
          required String icon,
          required Color color,
          required VoidCallback onPressed,
        }) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: onPressed,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: Center(
                  child: Iconify(
                    icon,
                    size: 36,
                  ),
                ),
              ),
            ),
          );
        }

}