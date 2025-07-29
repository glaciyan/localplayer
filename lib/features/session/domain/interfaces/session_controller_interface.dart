abstract class ISessionController {
  void loadSession();
  void createSession(
    final double latitude,
    final double longitude,
    final String name,
    final bool open,
  );
  void closeSession(final int id);
  void joinSession(final int sessionId);
  void respondToRequest(
    final int participantId,
    final int sessionId,
    final bool accept,
  );
}