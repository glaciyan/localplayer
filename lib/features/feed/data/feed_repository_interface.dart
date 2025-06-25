import 'package:localplayer/features/feed/domain/models/NotificationModel.dart';

abstract class IFeedRepository {
  Future<List<NotificationModel>> fetchNotifications();
  Future<bool> acceptSession(final int userId, final int sessionId);
  Future<bool> rejectSession(final int userId, final int sessionId);
  Future<void> pingUser(final int userId);
}