abstract class IFeedController {
  void loadFeed();
  void refreshFeed();
  void acceptSession(final int sessionId, final int userId);
  void rejectSession(final int sessionId, final int userId);
}