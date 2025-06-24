abstract class IFeedController {
  void loadFeed();
  void refreshFeed();
  void acceptSession(final String sessionId, final String userId);
  void rejectSession(final String sessionId, final String userId);
}