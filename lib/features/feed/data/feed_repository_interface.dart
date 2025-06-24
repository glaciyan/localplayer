import 'package:localplayer/features/feed/domain/models/NotificationModel.dart';

abstract class IFeedRepository {
  Future<List<NotificationModel>> fetchNotifications();
  Future<void> acceptSession(final String sessionId, final String userId);
  Future<void> rejectSession(final String sessionId, final String userId);
}