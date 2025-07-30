import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_state.dart';
import 'package:localplayer/features/feed/domain/models/NotificationModel.dart';

void main() {
  group('FeedState', () {
    test('FeedInitial should be instance of FeedInitial', () {
      // Arrange & Act
      final FeedInitial state = FeedInitial();

      // Assert
      expect(state, isA<FeedInitial>());
    });

    test('FeedLoading should be instance of FeedLoading', () {
      // Arrange & Act
      final FeedLoading state = FeedLoading();

      // Assert
      expect(state, isA<FeedLoading>());
    });

    test('FeedLoaded should have correct properties', () {
      // Arrange
      final List<NotificationModel> notifications = <NotificationModel>[];
      const bool hasMore = true;

      // Act
      final FeedLoaded state = FeedLoaded(notifications: notifications, hasMore: hasMore);

      // Assert
      expect(state.notifications, equals(notifications));
      expect(state.hasMore, equals(hasMore));
    });

    test('FeedLoaded should have default hasMore value', () {
      // Arrange
      final List<NotificationModel> notifications = <NotificationModel>[];

      // Act
      final FeedLoaded state = FeedLoaded(notifications: notifications);

      // Assert
      expect(state.hasMore, equals(true));
    });

    test('FeedError should have correct message', () {
      // Arrange
      const String message = 'Test error message';

      // Act
      final FeedError state = FeedError(message);

      // Assert
      expect(state.message, equals(message));
    });

    test('PingUserSuccess should have correct notifications', () {
      // Arrange
      final List<NotificationModel> notifications = <NotificationModel>[];

      // Act
      final PingUserSuccess state = PingUserSuccess(notifications);

      // Assert
      expect(state.notifications, equals(notifications));
    });

    test('PingUserError should have correct message', () {
      // Arrange
      const String message = 'Ping error message';

      // Act
      final PingUserError state = PingUserError(message);

      // Assert
      expect(state.message, equals(message));
    });

    test('FeedLoaded should have correct notifications and hasMore', () {
      // Arrange
      final List<NotificationModel> notifications = <NotificationModel>[];
      const bool hasMore = false;

      // Act
      final FeedLoaded state = FeedLoaded(notifications: notifications, hasMore: hasMore);

      // Assert
      expect(state.notifications, equals(notifications));
      expect(state.hasMore, equals(hasMore));
    });
  });
} 