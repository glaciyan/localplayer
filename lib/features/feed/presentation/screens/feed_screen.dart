import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/widgets/with_nav_bar.dart';
import 'package:localplayer/features/feed/feed_module.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_event.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_state.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(final BuildContext context) => BlocProvider<FeedBloc>(
    create: (_) => FeedModule.provideBloc()..add(LoadFeed()),
    child: const WithNavBar(
      selectedIndex: 2,
      child: FeedWidget(),
    ),
  );
}

class FeedWidget extends StatelessWidget {
  const FeedWidget({super.key});

  @override
  Widget build(final BuildContext context) => BlocBuilder<FeedBloc, FeedState>(
    builder: (final BuildContext context, final FeedState state) {
      if (state is FeedLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (state is FeedError) {
        return Center(child: Text('Error: ${state.message}'));
      }
      
      if (state is FeedLoaded) {
        return ListView.builder(
          itemCount: state.posts.length,
          itemBuilder: (context, index) {
            final post = state.posts[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(post.author.avatarUrl),
                ),
                title: Text(post.author.displayName ?? post.author.handle),
                subtitle: Text(post.content),
                trailing: IconButton(
                  icon: Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: post.isLiked ? Colors.red : null,
                  ),
                  onPressed: () {
                    if (post.isLiked) {
                      context.read<FeedBloc>().add(UnlikePost(post.id));
                    } else {
                      context.read<FeedBloc>().add(LikePost(post.id));
                    }
                  },
                ),
              ),
            );
          },
        );
      }
      
      return const Center(child: Text('No posts available'));
    },
  );
}