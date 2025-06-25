import 'package:localplayer/features/feed/domain/models/NotificationModel.dart';

abstract class IFeedRepository {
  Future<List<NotificationModel>> fetchNotifications();
  Future<void> acceptSession(final int sessionId, final int userId);
  Future<void> rejectSession(final int sessionId, final int userId);
}