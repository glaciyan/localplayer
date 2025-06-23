import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/widgets/profile_card.dart';
import 'package:localplayer/features/match/domain/controllers/match_controller_interface.dart';
import 'package:localplayer/features/match/match_module.dart';
import 'package:localplayer/features/match/presentation/blocs/match_bloc.dart';
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
    if (profiles.isEmpty) {
      return const Center(child: Text('No more profiles.'));
    } 

    return SafeArea(
      child: Stack(
        children: <Widget> [
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


  Widget _buildCardSwiper(final List<ProfileWithSpotify> profiles) =>CardSwiper(
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
      cardBuilder: (final BuildContext context, final int index, final int percentX, final int percentY) {
        final ProfileWithSpotify profile = profiles[index];
        return BlocProvider<SpotifyProfileCubit>.value(
          value: context.read<SpotifyProfileCubit>(),
          child: KeyedSubtree(
            key: ValueKey<String>(profile.user.spotifyId),
            child: ProfileCard(profile: profile),
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
        return true;
      },
    );

  Widget _buildSwipeButtons(final BuildContext context, final List<ProfileWithSpotify> profiles) {
    void handleSwipe(final CardSwiperDirection direction) {
      if (_currentIndex >= profiles.length) return;
      final ProfileWithSpotify profile = profiles[_currentIndex];

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
                ),
              ),
            ),
          ),
        );
  }