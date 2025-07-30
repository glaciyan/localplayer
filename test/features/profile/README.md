# Profile Feature Tests

This directory contains tests for the profile feature of the LocalPlayer app.

## Test Structure

- `profile_test_suite.dart` - Main test suite that runs all profile tests
- `presentation/blocs/profile_event_test.dart` - Tests for profile events
- `presentation/blocs/profile_state_test.dart` - Tests for profile states  
- `presentation/blocs/profile_bloc_test.dart` - Tests for profile bloc behavior

## Running Tests

### Run all profile tests:
```bash
flutter test test/features/profile/profile_test_suite.dart
```

### Run individual test files:
```bash
flutter test test/features/profile/presentation/blocs/profile_event_test.dart
flutter test test/features/profile/presentation/blocs/profile_state_test.dart
flutter test test/features/profile/presentation/blocs/profile_bloc_test.dart
```

## Test Coverage

### ProfileEvent Tests
- Event property validation
- Event type checking
- Event instantiation testing

### ProfileState Tests
- State property validation
- State type checking
- State property testing (updated flag)

### ProfileBloc Tests
- Event instantiation and property validation
- State instantiation and property validation
- Basic event and state functionality

## Test Coverage

### ProfileEvent Tests
- LoadProfile event creation and null updatedProfile
- ProfileUpdated event with displayName and biography
- UpdateProfile event with ProfileWithSpotify
- SignOut event creation
- ProfileUpdateSuccess event creation

### ProfileState Tests
- ProfileLoading state instantiation
- ProfileLoaded state with profile and updated flag
- ProfileLoaded state with updated = true
- ProfileSignedOut state instantiation
- ProfileError state with error message
- ProfileUpdateSuccess state instantiation

### ProfileBloc Tests
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
- Tests ensure the updated flag in ProfileLoaded works correctly
