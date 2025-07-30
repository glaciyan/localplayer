# Map Feature Tests

This directory contains tests for the map feature of the LocalPlayer app.

## Test Structure

- `map_test_suite.dart` - Main test suite that runs all map tests
- `presentation/blocs/map_event_test.dart` - Tests for map events
- `presentation/blocs/map_state_test.dart` - Tests for map states  
- `presentation/blocs/map_bloc_test.dart` - Tests for map bloc behavior

## Running Tests

### Run all map tests:
```bash
flutter test test/features/map/map_test_suite.dart
```

### Run individual test files:
```bash
flutter test test/features/map/presentation/blocs/map_event_test.dart
flutter test test/features/map/presentation/blocs/map_state_test.dart
flutter test test/features/map/presentation/blocs/map_bloc_test.dart
```

## Test Coverage

### MapEvent Tests
- Event property validation
- Event type checking
- Event instantiation testing

### MapState Tests
- State property validation
- State type checking
- State copyWith functionality

### MapBloc Tests
- Event instantiation and property validation
- Basic event handling verification

## Test Coverage

### MapEvent Tests
- InitializeMap event creation
- LoadMapProfiles event creation
- SelectPlayer event with user profile
- RequestJoinSession event with user profile
- LeaveSession event creation
- UpdateCameraPosition event with coordinates and bounds
- DeselectPlayer event with user profile and coordinates

### MapState Tests
- MapInitial state instantiation
- MapLoading state instantiation
- MapError state with error message
- MapReady state with all properties
- MapReady copyWith functionality
- MapProfileSelected state with all properties
- MapProfileSelected copyWith functionality

### MapBloc Tests
- Event instantiation and property validation
- Event type checking
- Event property verification

## Dependencies

The tests use:
- `flutter_test` for basic testing
- `flutter_map` for map-related types
- `latlong2` for coordinate types
- `flutter/material.dart` for Color and other Flutter types

## Notes

- The tests focus on basic functionality and property validation
- Complex bloc behavior testing is simplified to avoid complex mocking
- Tests verify that events and states can be created correctly with proper properties 