import 'package:flutter/material.dart';
import 'package:localplayer/features/feed/domain/models/NotificationModel.dart';
import 'package:localplayer/features/feed/presentation/widgets/feed_post.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_state.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_event.dart';
import 'package:localplayer/features/feed/domain/controllers/feed_controller.dart';

class FeedWidget extends StatefulWidget {
  const FeedWidget({super.key});

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(final BuildContext context) {
    final FeedController _feedController = FeedController(context, (final FeedEvent event) => context.read<FeedBloc>().add(event));

    return BlocBuilder<FeedBloc, FeedState>(  
      builder: (final BuildContext context, final FeedState state) {
        if (state is FeedLoaded) {
          return Scaffold(
            body: SafeArea(
              child: RefreshIndicator(
                color: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.surface,
                onRefresh: () async {
                  _feedController.refreshFeed();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                    child: Column(
                      children: <Widget> [
                              for (final NotificationModel post in state.posts) SizedBox(width: double.infinity, child: FeedPost(post: post))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        
        return Scaffold(
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget> [
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}