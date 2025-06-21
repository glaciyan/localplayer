import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/widgets/profile_card.dart';
import 'package:localplayer/features/match/domain/controllers/IMatchController.dart';
import 'package:localplayer/features/match/domain/entities/user_profile.dart';
import 'package:localplayer/features/match/match_module.dart';
import 'package:localplayer/features/match/presentation/blocs/match_block.dart';
import 'package:tcard/tcard.dart';
import '../blocs/match_event.dart';
import '../blocs/match_state.dart';

class MatchWidget extends StatefulWidget {
  const MatchWidget({super.key});

  @override
  State<MatchWidget> createState() => _MatchWidgetState();
}

class _MatchWidgetState extends State<MatchWidget> {
  late final TCardController _cardController;
  late final IMatchController _matchController;
  late List<UserProfile> _profiles;

  @override
  void initState() {
    super.initState();
    _cardController = TCardController();
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

          final cards = _profiles.map((profile) {
            return ProfileCard(
              avatarLink: profile.getAvatarLink(),
              backgroundLink: profile.getBckgroundLink(),
            );
          }).toList();

          return Column(
            children: [
              Expanded(
                child: TCard(
                  controller: _cardController,
                  cards: cards,
                  size: MediaQuery.of(context).size,
                  onForward: (index, info) {
                    if (index == null || index >= _profiles.length) return;
                    final profile = _profiles[index];
                    if (info.direction == SwipDirection.Right) {
                      _matchController.like(profile);
                    } else if (info.direction == SwipDirection.Left) {
                      _matchController.dislike(profile);
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Dislike button
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red, size: 40),
                    onPressed: () {
                      _cardController.forward(direction: SwipDirection.Left);
                      final currentIndex = _cardController.index;
                      if (currentIndex < _profiles.length) {
                        _matchController.dislike(_profiles[currentIndex]);
                      }
                    },
                  ),
                  const SizedBox(width: 60),
                  // Like button
                  IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.green, size: 40),
                    onPressed: () {
                      _cardController.forward(direction: SwipDirection.Right);
                      final currentIndex = _cardController.index;
                      if (currentIndex < _profiles.length) {
                        _matchController.like(_profiles[currentIndex]);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
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