import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/widgets/with_nav_bar.dart';
import 'package:localplayer/features/feed/feed_module.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_event.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_state.dart';
import 'package:localplayer/features/feed/presentation/widgets/feed_widget.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(final BuildContext context) => BlocProvider<FeedBloc>(
    create: (_) => FeedModule.provideBloc()..add(LoadFeed()),
    child: const WithNavBar(
      selectedIndex: 2,
      child: FeedContent(),
    ),
  );
}

class FeedContent extends StatelessWidget {
  const FeedContent({super.key});

  @override
  Widget build(final BuildContext context) => BlocBuilder<FeedBloc, FeedState>(
    builder: (final BuildContext context, final FeedState state) {
      if (state is FeedLoading) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      
      if (state is FeedError) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${state.message}', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<FeedBloc>().add(TestEvent());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }
      
      if (state is FeedLoaded) {
        return const FeedWidget();
      }
      
      return const Scaffold(
        body: Center(child: Text('No posts available')),
      );
    },
  );
}