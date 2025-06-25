abstract class FeedEvent {}

class LoadFeed extends FeedEvent {}

class RefreshFeed extends FeedEvent {}

class AcceptSession extends FeedEvent {
  final int sessionId;
  final int userId;

  AcceptSession(this.sessionId, this.userId);
}

class RejectSession extends FeedEvent {
  final int sessionId;
  final int userId;

  RejectSession(this.sessionId, this.userId);
}