import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_state.dart';
import 'package:localplayer/features/feed/domain/models/NotificationModel.dart';
import 'package:localplayer/core/entities/user_profile.dart';

void main() {
  group('FeedState', () {
    test('FeedInitial should be instance of FeedInitial', () {
      // Arrange & Act
      final state = FeedInitial();

      // Assert
      expect(state, isA<FeedInitial>());
    });

    test('FeedLoading should be instance of FeedLoading', () {
      // Arrange & Act
      final state = FeedLoading();

      // Assert
      expect(state, isA<FeedLoading>());
    });

    test('FeedLoaded should have correct properties', () {
      // Arrange
      final notifications = <NotificationModel>[];
      const hasMore = true;

      // Act
      final state = FeedLoaded(notifications: notifications, hasMore: hasMore);

      // Assert
      expect(state.notifications, equals(notifications));
      expect(state.hasMore, equals(hasMore));
    });

    test('FeedLoaded should have default hasMore value', () {
      // Arrange
      final notifications = <NotificationModel>[];

      // Act
      final state = FeedLoaded(notifications: notifications);

      // Assert
      expect(state.hasMore, equals(true));
    });

    test('FeedError should have correct message', () {
      // Arrange
      const message = 'Test error message';

      // Act
      final state = FeedError(message);

      // Assert
      expect(state.message, equals(message));
    });

    test('PingUserSuccess should have correct notifications', () {
      // Arrange
      final notifications = <NotificationModel>[];

      // Act
      final state = PingUserSuccess(notifications);

      // Assert
      expect(state.notifications, equals(notifications));
    });

    test('PingUserError should have correct message', () {
      // Arrange
      const message = 'Ping error message';

      // Act
      final state = PingUserError(message);

      // Assert
      expect(state.message, equals(message));
    });

    test('FeedLoaded should have correct notifications and hasMore', () {
      // Arrange
      final notifications = <NotificationModel>[];
      const hasMore = false;

      // Act
      final state = FeedLoaded(notifications: notifications, hasMore: hasMore);

      // Assert
      expect(state.notifications, equals(notifications));
      expect(state.hasMore, equals(hasMore));
    });
  });
} 