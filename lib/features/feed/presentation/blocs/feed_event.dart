abstract class FeedEvent {}

class LoadFeed extends FeedEvent {}

class RefreshFeed extends FeedEvent {}

class LoadMorePosts extends FeedEvent {}

class LikePost extends FeedEvent {
  final String postId;
  LikePost(this.postId);
}

class UnlikePost extends FeedEvent {
  final String postId;
  UnlikePost(this.postId);
}
