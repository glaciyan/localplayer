import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/features/feed/domain/models/NotificationModel.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/features/session/domain/models/session_model.dart';

void main() {
  group('NotificationModel', () {
    test('should create NotificationModel from valid JSON', () {
      // Arrange
      final Map<String, Object> json = <String, Object> {
        'id': 1,
        'createdAt': '2024-01-01T12:00:00Z',
        'title': 'Test Notification',
        'message': 'Test message',
        'read': false,
        'type': 'session_requested',
        'sender': {
          'id': 1,
          'handle': 'testuser',
          'displayName': 'Test User',
          'biography': 'Test bio',
          'avatarLink': 'test.jpg',
          'backgroundLink': '',
          'location': '',
          'spotifyId': '',
          'color': '#FF0000',
          'listeners': 0,
          'likes': 0,
          'dislikes': 0,
          'popularity': 0,
          'sessionStatus': null,
          'createdAt': null,
          'participating': null,
          'sessionId': null,
        },
        'session': {
          'id': 1,
          'name': 'Test Session',
          'status': 'active',
          'createdAt': '2024-01-01T12:00:00Z',
          'updateAt': '2024-01-01T12:00:00Z',
        },
      };

      // Act
      final notification = NotificationModel.fromJson(json);

      // Assert
      expect(notification.id, equals(1));
      expect(notification.title, equals('Test Notification'));
      expect(notification.message, equals('Test message'));
      expect(notification.read, equals(false));
      expect(notification.type, equals(NotificationType.sessionInvite));
      expect(notification.sender, isA<UserProfile>());
      expect(notification.session, isA<SessionModel>());
    });

    test('should handle JSON without session', () {
      // Arrange
      final json = {
        'id': 1,
        'createdAt': '2024-01-01T12:00:00Z',
        'title': 'Test Notification',
        'message': null,
        'read': true,
        'type': 'like',
        'sender': {
          'id': 1,
          'handle': 'testuser',
          'displayName': 'Test User',
          'biography': 'Test bio',
          'avatarLink': 'test.jpg',
          'backgroundLink': '',
          'location': '',
          'spotifyId': '',
          'color': '#FF0000',
          'listeners': 0,
          'likes': 0,
          'dislikes': 0,
          'popularity': 0,
          'sessionStatus': null,
          'createdAt': null,
          'participating': null,
          'sessionId': null,
        },
        'session': null,
      };

      // Act
      final notification = NotificationModel.fromJson(json);

      // Assert
      expect(notification.id, equals(1));
      expect(notification.message, isNull);
      expect(notification.read, equals(true));
      expect(notification.type, equals(NotificationType.like));
      expect(notification.session, isNull);
    });

    test('should parse different notification types correctly', () {
      final testCases = [
        {'type': 'session_requested', 'expected': NotificationType.sessionInvite},
        {'type': 'session_request_accepted', 'expected': NotificationType.sessionAccepted},
        {'type': 'session_request_rejected', 'expected': NotificationType.sessionRejected},
        {'type': 'like', 'expected': NotificationType.like},
        {'type': 'dislike', 'expected': NotificationType.dislike},
        {'type': 'unknown', 'expected': NotificationType.other},
      ];

      for (final testCase in testCases) {
        final json = {
          'id': 1,
          'createdAt': '2024-01-01T12:00:00Z',
          'title': 'Test',
          'read': false,
          'type': testCase['type'],
          'sender': {
            'id': 1,
            'handle': 'testuser',
            'displayName': 'Test User',
            'biography': 'Test bio',
            'avatarLink': 'test.jpg',
            'backgroundLink': '',
            'location': '',
            'spotifyId': '',
            'color': '#FF0000',
            'listeners': 0,
            'likes': 0,
            'dislikes': 0,
            'popularity': 0,
            'sessionStatus': null,
            'createdAt': null,
            'participating': null,
            'sessionId': null,
          },
        };

        final notification = NotificationModel.fromJson(json);
        expect(notification.type, equals(testCase['expected']));
      }
    });
  });
} 