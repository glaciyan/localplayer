import 'package:localplayer/features/feed/presentation/blocs/feed_event.dart';

abstract class IFeedController {
  void loadFeed();
  void refreshFeed();
  void loadMorePosts();
  void likePost(String postId);
  void unlikePost(String postId);
}
