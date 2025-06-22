enum NotificationType {
  sessionInvite,
  sessionAccepted,
  sessionRejected,
  newMessage,
  like,
  follow,
  other,
}

class NotificationModel {
  final int id;
  final int artistId;
  final String backgroundLink;
  final DateTime createdAt;
  final String title;
  final String? message;
  final bool read;
  final NotificationType type;
  final int? sessionId;
  final int? senderId;
  final int recipientId;

  NotificationModel({
    required this.id,
    required this.artistId,
    required this.backgroundLink,
    required this.createdAt,
    required this.title,
    this.message,
    required this.read,
    required this.type,
    this.sessionId,
    this.senderId,
    required this.recipientId,
  });

  factory NotificationModel.fromJson(final Map<String, dynamic> json) => NotificationModel(
    id: json['id'] as int,
    artistId: json['artistId'] as int,
    backgroundLink: json['backgroundLink'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    title: json['title'] as String,
    message: json['message'] as String?,
    read: json['read'] as bool,
    type: _parseNotificationType(json['type'] as String),
    sessionId: json['sessionId'] as int?,
    senderId: json['senderId'] as int?,
    recipientId: json['recipientId'] as int,
  );

  static NotificationType _parseNotificationType(final String type) {
    switch (type.toLowerCase()) {
      case 'session_invite':
        return NotificationType.sessionInvite;
      case 'session_accepted':
        return NotificationType.sessionAccepted;
      case 'session_rejected':
        return NotificationType.sessionRejected;
      case 'new_message':
        return NotificationType.newMessage;
      case 'like':
        return NotificationType.like;
      case 'follow':
        return NotificationType.follow;
      default:
        return NotificationType.other;
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic> {
    'id': id,
    'artistId': artistId,
    'backgroundLink': backgroundLink,
    'createdAt': createdAt.toIso8601String(),
    'title': title,
    'message': message,
    'read': read,
    'type': type.name,
    'sessionId': sessionId,
    'senderId': senderId,
    'recipientId': recipientId,
  };
} 