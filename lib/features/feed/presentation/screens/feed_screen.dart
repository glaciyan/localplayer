import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/widgets/with_nav_bar.dart';
import 'package:localplayer/features/feed/data/feed_repository_interface.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_event.dart';
import 'package:localplayer/features/feed/presentation/widgets/feed_widget.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(final BuildContext context) => BlocProvider<FeedBloc>(
    create: (_) => FeedBloc(
      feedRepository: context.read<IFeedRepository>(),
    )..add(RefreshFeed()),
    child: WithNavBar(
      selectedIndex: 2,
      child: SafeArea(
        child: Column(
          children: <Widget> [
            Text("Feed", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
            Expanded(child: FeedWidget()),
          ],
        ),
      ),
    ),
  );
}