import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:localplayer/core/widgets/with_nav_bar.dart';
import 'package:localplayer/features/match/presentation/blocs/match_block.dart';
import 'package:localplayer/features/match/presentation/blocs/match_event.dart';
import '../blocs/match_state.dart';
import '../widgets/profile_card.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final swiperController = CardSwiperController();

    return WithNavBar(
      selectedIndex: 1,
      child: BlocBuilder<MatchBloc, MatchState>(
        builder: (context, state) {
          if (state is MatchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MatchLoaded) {
            final profiles = state.profiles;

            if (profiles.isEmpty) {
              return const Center(child: Text('No more profiles.'));
            }

            return CardSwiper(
              controller: swiperController,
              cardsCount: profiles.length,
              numberOfCardsDisplayed: profiles.length >= 2 ? 2 : 1,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              cardBuilder: (context, index, percentX, percentY) {
                if (index >= profiles.length) return const SizedBox();
                return ProfileCard(profile: profiles[index]);
              },
              onSwipe: (previousIndex, currentIndex, direction) {
                if (previousIndex >= profiles.length) return true;

                final swipedProfile = profiles[previousIndex];
                final bloc = context.read<MatchBloc>();

                if (direction == CardSwiperDirection.right) {
                  bloc.add(LikePressed(swipedProfile));
                } else if (direction == CardSwiperDirection.left) {
                  bloc.add(DislikePressed(swipedProfile));
                }

                return true;
              },
            );
          } else if (state is MatchInitial) {
            return const Center(child: Text('Swipe to find matches!'));

          } else if (state is MatchError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('No profiles found.'));
          }
        },
      ),
    );
  }
}
