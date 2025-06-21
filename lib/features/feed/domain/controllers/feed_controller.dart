import 'package:flutter/material.dart';
import 'package:localplayer/features/feed/domain/interfaces/feed_controller_interface.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_event.dart';

class FeedController implements IFeedController {
  final BuildContext context;
  final Function(FeedEvent) addEvent;

  FeedController(this.context, this.addEvent);

  @override
  void loadFeed() => addEvent(LoadFeed());

  @override
  void refreshFeed() => addEvent(RefreshFeed());

  @override
  void loadMorePosts() => addEvent(LoadMorePosts());

  @override
  void likePost(String postId) => addEvent(LikePost(postId));

  @override
  void unlikePost(String postId) => addEvent(UnlikePost(postId));
}
