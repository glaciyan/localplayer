import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:localplayer/core/widgets/profile_card.dart';
import 'package:localplayer/features/match/domain/controllers/IMatchController.dart';
import 'package:localplayer/features/match/domain/entities/user_profile.dart';
import 'package:localplayer/features/match/match_module.dart';
import 'package:localplayer/features/match/presentation/blocs/match_block.dart';
import 'package:localplayer/features/match/presentation/blocs/match_state.dart';

class MatchWidget extends StatefulWidget {
  const MatchWidget({super.key});

  @override
  State<MatchWidget> createState() => _MatchWidgetState();
}

class _MatchWidgetState extends State<MatchWidget> {
  late final CardSwiperController _swiperController;
  late final IMatchController _matchController;
  late List<UserProfile> _profiles;
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
        if (state is MatchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MatchLoaded) {
          _profiles = state.profiles;

          if (_profiles.isEmpty) {
            return const Center(child: Text('No more profiles.'));
          }

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SizedBox.expand(
                    child: CardSwiper(
                      controller: _swiperController,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30), // Increase vertical
                      numberOfCardsDisplayed: 2, // Ensures stacking look
                      backCardOffset: const Offset(0, 20), // Show card behind
                      maxAngle: 30, // Reduce if you want less rotation on swipe
                      threshold: 60, // Lower threshold = easier swipe
                      allowedSwipeDirection: const AllowedSwipeDirection.symmetric(
                        horizontal: true,
                        vertical: false,
                      ),
                      cardsCount: _profiles.length,
                      cardBuilder: (context, index, percentX, percentY) {
                        final profile = _profiles[index];
                        return ProfileCard(
                          avatarLink: profile.getAvatarLink(),
                          backgroundLink: profile.getBckgroundLink(),
                        );
                      },
                      onSwipe: (previousIndex, currentIndex, direction) {
                        if (currentIndex == null || currentIndex >= _profiles.length) return true;
                        final profile = _profiles[currentIndex];
                        if (direction == CardSwiperDirection.right) {
                          _matchController.like(profile);
                        } else if (direction == CardSwiperDirection.left) {
                          _matchController.dislike(profile);
                        }
                        return true;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).highlightColor,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  if (_currentIndex < _profiles.length) {
                                    _matchController.dislike(_profiles[_currentIndex]);
                                    _swiperController.swipe(CardSwiperDirection.left);
                                  }
                                },
                                icon: const Iconify(
                                  IconParkSolid.dislike_two,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  if (_currentIndex < _profiles.length) {
                                    _matchController.like(_profiles[_currentIndex]);
                                    _swiperController.swipe(CardSwiperDirection.right);
                                  }
                                },
                                icon: Iconify(
                                  IconParkSolid.like,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        } else if (state is MatchInitial) {
          return const Center(child: Text('Swipe to find matches!'));
        } else if (state is MatchError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('No profiles found.'));
        }
      },
    );
  }
}
