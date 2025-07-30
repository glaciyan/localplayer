# Feed Feature Tests

This directory contains tests for the feed feature of the LocalPlayer app.

## Test Structure

- `feed_test_suite.dart` - Main test suite that runs all feed tests
- `domain/models/notification_model_test.dart` - Tests for NotificationModel parsing
- `presentation/blocs/feed_event_test.dart` - Tests for feed events
- `presentation/blocs/feed_state_test.dart` - Tests for feed states  
- `presentation/blocs/feed_bloc_test.dart` - Tests for FeedBloc behavior

## Running Tests

### Run all feed tests:
```bash
flutter test test/features/feed/feed_test_suite.dart
```

### Run individual test files:
```bash
flutter test test/features/feed/domain/models/notification_model_test.dart
flutter test test/features/feed/presentation/blocs/feed_event_test.dart
flutter test test/features/feed/presentation/blocs/feed_state_test.dart
flutter test test/features/feed/presentation/blocs/feed_bloc_test.dart
```

## Test Coverage

### NotificationModel Tests
- JSON parsing with valid data
- Handling null session data
- Different notification type parsing

### FeedEvent Tests
- Event property validation
- Event equality testing

### FeedState Tests
- State property validation
- State equality testing

### FeedBloc Tests
- Initial state verification
- Event handling and state transitions
- Error handling
- Repository method calls
- Session bloc integration

## Dependencies

The tests use:
- `flutter_test` for basic testing
- `bloc_test` for bloc testing
- `mockito` for mocking dependencies

Make sure to run `flutter packages pub run build_runner build` after modifying bloc tests to regenerate mocks. 