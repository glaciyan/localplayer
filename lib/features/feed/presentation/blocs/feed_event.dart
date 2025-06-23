abstract class FeedEvent {}

class LoadFeed extends FeedEvent {}

class RefreshFeed extends FeedEvent {}

class TestEvent extends FeedEvent {}

class AcceptSession extends FeedEvent {
  final String sessionId;
  final String userId;

  AcceptSession(this.sessionId, this.userId);
}

class RejectSession extends FeedEvent {
  final String sessionId;
  final String userId;

  RejectSession(this.sessionId, this.userId);
}