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
    final FeedController _feedController = FeedController(
      context,
      (final FeedEvent event) => context.read<FeedBloc>().add(event),
    );

    return BlocBuilder<FeedBloc, FeedState>(
      builder: (final BuildContext context, final FeedState state) {
        if (state is FeedLoaded || state is PingUserSuccess) {
          final List<NotificationModel> notifications = state is FeedLoaded
              ? state.notifications
              : (state as PingUserSuccess).notifications;

          return RefreshIndicator(
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.surface,
            onRefresh: () async {
              _feedController.refreshFeed();
            },
            child: CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              slivers: <Widget>[
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: notifications.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Text(
                                  "No notifications",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.black),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: Text(
                                  "Pull down to refresh",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.black),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: <Widget>[
                              for (final NotificationModel post in notifications)
                                SizedBox(
                                  width: double.infinity,
                                  child: FeedPost(
                                    post: post,
                                    feedController: _feedController,
                                  ),
                                ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is FeedLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FeedError) {
          return RefreshIndicator(
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.surface,
            onRefresh: () async {
              _feedController.refreshFeed();
            },
            child: CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              slivers: <Widget>[
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      state.message,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: <Widget> [
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
