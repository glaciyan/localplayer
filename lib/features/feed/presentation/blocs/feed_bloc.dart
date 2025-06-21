// features/feed/presentation/blocs/feed/feed_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/features/feed/data/datasources/feed_remote_data_source.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRemoteDataSource feedRemoteDataSource;

  FeedBloc(this.feedRemoteDataSource) : super(FeedInitial()) {
    on<LoadFeed>((final LoadFeed event, final Emitter<FeedState> emit) async {
      emit(FeedLoading());
      try {
        final posts = await feedRemoteDataSource.fetchFeedPosts();
        emit(FeedLoaded(posts: posts));
      } catch (e) {
        emit(FeedError(e.toString()));
      }
    });

    on<RefreshFeed>((final RefreshFeed event, final Emitter<FeedState> emit) async {
      try {
        final posts = await feedRemoteDataSource.fetchFeedPosts();
        emit(FeedLoaded(posts: posts));
      } catch (e) {
        emit(FeedError(e.toString()));
      }
    });

    on<LoadMorePosts>((final LoadMorePosts event, final Emitter<FeedState> emit) async {
      if (state is FeedLoaded) {
        final currentState = state as FeedLoaded;
        try {
          final morePosts = await feedRemoteDataSource.fetchMorePosts();
          final allPosts = [...currentState.posts, ...morePosts];
          emit(FeedLoaded(posts: allPosts, hasMore: morePosts.isNotEmpty));
        } catch (e) {
          emit(FeedError(e.toString()));
        }
      }
    });

    on<LikePost>((final LikePost event, final Emitter<FeedState> emit) async {
      try {
        await feedRemoteDataSource.likePost(event.postId);
        // Update the post in the current state
        if (state is FeedLoaded) {
          final currentState = state as FeedLoaded;
          final updatedPosts = currentState.posts.map((post) {
            if (post.id == event.postId) {
              return FeedPost(
                id: post.id,
                author: post.author,
                content: post.content,
                imageUrl: post.imageUrl,
                createdAt: post.createdAt,
                likeCount: post.likeCount + 1,
                isLiked: true,
                spotifyTrackId: post.spotifyTrackId,
              );
            }
            return post;
          }).toList();
          emit(FeedLoaded(posts: updatedPosts, hasMore: currentState.hasMore));
        }
      } catch (e) {
        emit(FeedError(e.toString()));
      }
    });

    on<UnlikePost>((final UnlikePost event, final Emitter<FeedState> emit) async {
      try {
        await feedRemoteDataSource.unlikePost(event.postId);
        // Update the post in the current state
        if (state is FeedLoaded) {
          final currentState = state as FeedLoaded;
          final updatedPosts = currentState.posts.map((post) {
            if (post.id == event.postId) {
              return FeedPost(
                id: post.id,
                author: post.author,
                content: post.content,
                imageUrl: post.imageUrl,
                createdAt: post.createdAt,
                likeCount: post.likeCount - 1,
                isLiked: false,
                spotifyTrackId: post.spotifyTrackId,
              );
            }
            return post;
          }).toList();
          emit(FeedLoaded(posts: updatedPosts, hasMore: currentState.hasMore));
        }
      } catch (e) {
        emit(FeedError(e.toString()));
      }
    });
  }
}
