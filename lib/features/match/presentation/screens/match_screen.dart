import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:localplayer/core/widgets/with_nav_bar.dart';
import 'package:localplayer/features/match/presentation/blocs/match_block.dart';
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

            return SizedBox.expand(
            child: CardSwiper(
              controller: swiperController,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              numberOfCardsDisplayed: 2,
              maxAngle: 300,
              threshold: 90,
              allowedSwipeDirection: AllowedSwipeDirection.symmetric(horizontal: true, vertical: false),
              cardBuilder: (context, index, percentX, percentY) =>
                ProfileCard(
                  profile: profiles[index % profiles.length],
                  swiperController: swiperController,
                ),
              cardsCount: 10,
              backCardOffset: const Offset(0, 0),
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
      ),
    );
  }
}
