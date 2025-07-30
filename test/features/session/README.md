# Session Feature Tests

This directory contains tests for the session feature of the LocalPlayer app.

## Test Structure

- `session_test_suite.dart` - Main test suite that runs all session tests
- `presentation/blocs/session_event_test.dart` - Tests for session events
- `presentation/blocs/session_state_test.dart` - Tests for session states  
- `presentation/blocs/session_bloc_test.dart` - Tests for session bloc behavior

## Running Tests

### Run all session tests:
```bash
flutter test test/features/session/session_test_suite.dart
```

### Run individual test files:
```bash
flutter test test/features/session/presentation/blocs/session_event_test.dart
flutter test test/features/session/presentation/blocs/session_state_test.dart
flutter test test/features/session/presentation/blocs/session_bloc_test.dart
```

## Test Coverage

### SessionEvent Tests
- Event property validation
- Event type checking
- Event instantiation testing

### SessionState Tests
- State property validation
- State type checking
- SessionModel integration testing

### SessionBloc Tests
- Event instantiation and property validation
- State instantiation and property validation
- SessionModel creation and property testing

## Test Coverage

### SessionEvent Tests
- LoadSession event creation
- CreateSession event with latitude, longitude, name, and open flag
- CloseSession event with session id
- JoinSession event with session id
- RespondToRequest event with participantId, sessionId, and accept flag
- RespondToRequest event with accept = false
- LeaveSession event creation

### SessionState Tests
- SessionInitial state instantiation
- SessionLoading state instantiation
- SessionActive state with SessionModel
- SessionActive state with null position
- SessionInactive state instantiation
- SessionError state with error message

### SessionBloc Tests
- Event instantiation and property validation
- State instantiation and property validation
- SessionModel creation and property testing
- SessionModel with null position testing

## Dependencies

The tests use:
- `flutter_test` for basic testing
- `latlong2` for coordinate types
- `SessionModel` for session data structure

## Notes

- The tests focus on basic functionality and property validation
- Tests verify that events and states can be created correctly with proper properties
- Tests ensure SessionModel works correctly with and without position data
- Tests cover all session operations: load, create, close, join, respond, and leave
