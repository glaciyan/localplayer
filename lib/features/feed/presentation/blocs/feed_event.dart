abstract class FeedEvent {}

class LoadFeed extends FeedEvent {}

class RefreshFeed extends FeedEvent {}

class TestEvent extends FeedEvent {}

class AcceptSession extends FeedEvent {
  final String sessionId;

  AcceptSession(this.sessionId);
}

class RejectSession extends FeedEvent {
  final String sessionId;

  RejectSession(this.sessionId);
}