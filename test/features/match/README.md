# Match Feature Tests

This directory contains tests for the match feature of the LocalPlayer app.

## Test Structure

- `match_test_suite.dart` - Main test suite that runs all match tests
- `presentation/blocs/match_event_test.dart` - Tests for match events
- `presentation/blocs/match_state_test.dart` - Tests for match states  
- `presentation/blocs/match_bloc_test.dart` - Tests for match bloc behavior

## Running Tests

### Run all match tests:
```bash
flutter test test/features/match/match_test_suite.dart
```

### Run individual test files:
```bash
flutter test test/features/match/presentation/blocs/match_event_test.dart
flutter test test/features/match/presentation/blocs/match_state_test.dart
flutter test test/features/match/presentation/blocs/match_bloc_test.dart
```

## Test Coverage

### MatchEvent Tests
- Event property validation
- Event type checking
- Event instantiation testing

### MatchState Tests
- State property validation
- State type checking
- State copyWith functionality
- State computed properties (currentProfile, hasMore)

### MatchBloc Tests
- Event instantiation and property validation
- State instantiation and property validation
- Basic event and state functionality

## Test Coverage

### MatchEvent Tests
- LoadProfiles event creation
- MatchNextProfile event creation
- LikePressed event with user profile
- DislikePressed event with user profile

### MatchState Tests
- MatchInitial state instantiation
- MatchLoading state instantiation
- MatchError state with error message
- ToastedMatchError state with error message
- MatchLoaded state with all properties
- MatchLoaded copyWith functionality
- MatchLoaded computed properties (currentProfile, hasMore)

### MatchBloc Tests
- Event instantiation and property validation
- State instantiation and property validation
- Event and state type checking

## Dependencies

The tests use:
- `flutter_test` for basic testing
- `flutter/material.dart` for Color and other Flutter types
- `latlong2` for coordinate types

## Notes

- The tests focus on basic functionality and property validation
- Tests verify that events and states can be created correctly with proper properties
- Tests ensure computed properties work as expected
