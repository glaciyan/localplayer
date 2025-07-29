import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/widgets/with_nav_bar.dart';
import 'package:localplayer/features/feed/data/feed_repository_interface.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_event.dart';
import 'package:localplayer/features/feed/presentation/widgets/feed_widget.dart';
import 'package:localplayer/features/session/presentation/blocs/session_bloc.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(final BuildContext context) => BlocProvider<FeedBloc>(
    create: (_) => FeedBloc(
      feedRepository: context.read<IFeedRepository>(),
      sessionBloc: context.read<SessionBloc>(),
    )..add(RefreshFeed()),
    child: WithNavBar(
      selectedIndex: 2,
      child: SafeArea(
        child: Column(
          children: <Widget> [
            Expanded(child: FeedWidget()),
          ],
        ),
      ),
    ),
  );
}