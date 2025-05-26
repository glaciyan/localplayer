import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:localplayer/widgets/profile_card.dart';

class MatchScreen extends StatelessWidget {
  
  final List<ProfileCard> cards = const [
    ProfileCard(
      avatarLink: 'https://i1.sndcdn.com/avatars-000614099139-aooibr-t200x200.jpg',
      backgroundLink: 'https://i1.sndcdn.com/artworks-000639760858-c6kwhn-t200x200.jpg'
      ),
    ProfileCard(
      avatarLink: 'https://i1.sndcdn.com/avatars-000701366305-hu9f0i-t120x120.jpg', 
      backgroundLink: 'https://i1.sndcdn.com/artworks-j881nJdB8xP6-0-t500x500.jpg'
      ),
  ];

  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CardSwiper(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        numberOfCardsDisplayed: 2,
        maxAngle: 300,
        threshold: 90,
        allowedSwipeDirection: AllowedSwipeDirection.symmetric(horizontal: true, vertical: false),
        cardBuilder: (context, index, percentX, percentY) =>
            cards[index % cards.length],
        cardsCount: 10,
        backCardOffset: const Offset(0, 0),
      ),
    );
  }
}