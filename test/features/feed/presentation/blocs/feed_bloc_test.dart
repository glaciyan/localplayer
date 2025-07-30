import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_event.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_state.dart';
import 'package:localplayer/features/feed/data/feed_repository_interface.dart';
import 'package:localplayer/features/session/presentation/blocs/session_bloc.dart';
import 'package:localplayer/features/feed/domain/models/NotificationModel.dart';

// Generate mocks
@GenerateMocks(<Type>[IFeedRepository, SessionBloc])
import 'feed_bloc_test.mocks.dart';

void main() {
  group('FeedBloc', () {
    late MockIFeedRepository mockFeedRepository;
    late MockSessionBloc mockSessionBloc;
    late FeedBloc feedBloc;

    setUp(() {
      mockFeedRepository = MockIFeedRepository();
      mockSessionBloc = MockSessionBloc();
      feedBloc = FeedBloc(
        feedRepository: mockFeedRepository,
        sessionBloc: mockSessionBloc,
      );
    });

    tearDown(() {
      feedBloc.close();
    });

    test('initial state should be FeedInitial', () {
      expect(feedBloc.state, isA<FeedInitial>());
    });

    test('should handle RefreshFeed event successfully', () async {
      // Arrange
      when(mockFeedRepository.fetchNotifications()).thenAnswer(
        (_) async => <NotificationModel>[],
      );

      // Act
      feedBloc.add(RefreshFeed());

      // Assert - wait for async operation
      await Future<dynamic>.delayed(const Duration(milliseconds: 2000));
      expect(feedBloc.state, isA<FeedLoaded>());
    });

    test('should handle RefreshFeed event with error', () async {
      // Arrange
      when(mockFeedRepository.fetchNotifications()).thenThrow(
        Exception('Network error'),
      );

      // Act
      feedBloc.add(RefreshFeed());

      // Assert - wait for async operation
      await Future<dynamic>.delayed(const Duration(milliseconds: 2000));
      expect(feedBloc.state, isA<FeedError>());
    });



    test('should handle AcceptSession event', () {
      // Arrange
      when(mockSessionBloc.add(any)).thenReturn(null);
      feedBloc.emit(FeedLoaded(notifications: <NotificationModel>[]));

      // Act
      feedBloc.add(AcceptSession(1, 2));

      // Assert
      expect(feedBloc.state, isA<FeedLoaded>());
    });

    test('should handle RejectSession event', () {
      // Arrange
      when(mockSessionBloc.add(any)).thenReturn(null);
      feedBloc.emit(FeedLoaded(notifications: <NotificationModel>[]));

      // Act
      feedBloc.add(RejectSession(1, 2));

      // Assert
      expect(feedBloc.state, isA<FeedLoaded>());
    });

    test('should handle PingUser event', () async {
      // Arrange
      const int userId = 123;
      when(mockFeedRepository.pingUser(userId)).thenAnswer((_) async => null);
      feedBloc.emit(FeedLoaded(notifications: <NotificationModel>[]));

      // Act
      feedBloc.add(PingUser(userId));

      // Assert - wait for async operation
      await Future<dynamic>.delayed(const Duration(milliseconds: 2000));
      expect(feedBloc.state, isA<PingUserSuccess>());
    });
  });
} 