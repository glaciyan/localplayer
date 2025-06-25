import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/features/session/domain/models/session_model.dart';

enum NotificationType {
  sessionInvite,
  sessionAccepted,
  sessionRejected,
  dislike,
  like,
  follow,
  other,
}

class NotificationModel {
  final int id;
  final DateTime createdAt;
  final String title;
  final String? message;
  final bool read;
  final NotificationType type;
  final UserProfile sender;
  final SessionModel? session;

  NotificationModel({
    required this.id,
    required this.createdAt,
    required this.title,
    this.message,
    required this.read,
    required this.type,
    required this.sender,
    this.session,
  });

  factory NotificationModel.fromJson(final Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] as int,
        createdAt: DateTime.parse(json['createdAt'] as String),
        title: json['title'] as String,
        message: json['message'] as String?,
        read: json['read'] as bool,
        type: _parseNotificationType(json['type'] as String),
        sender: UserProfile.fromJson(json['sender'] as Map<String, dynamic>),
        session: json['session'] != null
            ? SessionModel.fromJson(json['session'] as Map<String, dynamic>)
            : null,
      );

  static NotificationType _parseNotificationType(final String type) {
    switch (type.toLowerCase()) {
      case 'session_requested':
        return NotificationType.sessionInvite;
      case 'session_request_accepted':
        return NotificationType.sessionAccepted;
      case 'session_request_rejected':
        return NotificationType.sessionRejected;
      case 'dislike':
        return NotificationType.dislike;
      case 'like':
        return NotificationType.like;
      default:
        return NotificationType.other;
    }
  }
}
