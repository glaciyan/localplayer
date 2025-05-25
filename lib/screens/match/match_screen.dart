import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:localplayer/widgets/profile_card.dart';

class MatchScreen extends StatelessWidget {
  
  final List<ProfileCard> cards = const [
    ProfileCard()
  ];

  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CardSwiper(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        numberOfCardsDisplayed: 2,
        maxAngle: 45,
        cardBuilder: (context, index, percentX, percentY) =>
            cards[index % cards.length],
        cardsCount: 10,
      ),
    );
  }
}