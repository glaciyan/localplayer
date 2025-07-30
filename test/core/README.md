# Core Tests

This directory contains tests for the core components of the LocalPlayer app.

## Test Structure

- `core_test_suite.dart` - Main test suite that runs all core tests
- `entities/hex_color_test.dart` - Tests for HexColor utility
- `entities/profile_with_spotify_test.dart` - Tests for ProfileWithSpotify entity
- `network/api_error_exception_test.dart` - Tests for API error exception
- `network/no_connection_exception_test.dart` - Tests for connection exception
- `services/toast_service_test.dart` - Tests for toast service
- `go_router/router_test.dart` - Tests for router configuration

## Running Tests

### Run all core tests:
```bash
flutter test test/core/core_test_suite.dart
```

### Run individual test files:
```bash
flutter test test/core/entities/hex_color_test.dart
flutter test test/core/entities/profile_with_spotify_test.dart
flutter test test/core/network/api_error_exception_test.dart
flutter test test/core/network/no_connection_exception_test.dart
flutter test test/core/services/toast_service_test.dart
flutter test test/core/go_router/router_test.dart
```

## Test Coverage

### HexColor Tests
- Hex color parsing from 6-digit strings
- Hex color parsing from 8-digit strings
- Hex color parsing with and without # prefix
- Case handling (uppercase, lowercase, mixed)
- Different color values (red, green, blue, white, black)

### ProfileWithSpotify Tests
- Entity creation with required properties
- Const constructor functionality
- User profile property access
- Artist data property access

### ApiErrorException Tests
- Default constructor with default values
- Custom message constructor
- Custom message and code constructor
- toString representation

### NoConnectionException Tests
- Default constructor with default message
- Custom message constructor
- toString representation

### ToastService Tests
- Static showError method existence
- Method call with different message types
- Error handling for various inputs

### Router Tests
- Router instance existence
- Initial location configuration
- Route definitions and counts
- Individual route path validation

## Test Coverage

### HexColor Tests (7 tests)
- 6-digit hex string parsing
- 6-digit hex string with # prefix
- 8-digit hex string parsing
- 8-digit hex string with # prefix
- Lowercase hex string handling
- Mixed case hex string handling
- Different color value testing

### ProfileWithSpotify Tests (4 tests)
- Entity creation with required properties
- Const constructor functionality
- User profile property access
- Artist data property access

### ApiErrorException Tests (5 tests)
- Default constructor testing
- Custom message constructor
- Custom message and code constructor
- toString with custom values
- toString with default values

### NoConnectionException Tests (4 tests)
- Default constructor testing
- Custom message constructor
- toString with custom message
- toString with default message

### ToastService Tests (4 tests)
- Static showError method existence
- Empty string message handling
- Long message handling
- Special characters handling

### Router Tests (10 tests)
- Router instance validation
- Initial location validation
- Routes existence validation
- Route count validation
- Individual route path validation (7 routes)

## Dependencies

The tests use:
- `flutter_test` for basic testing
- `flutter/material.dart` for Color and other Flutter types
- `latlong2` for coordinate types

## Notes

- The tests focus on basic functionality and property validation
- Tests verify that entities can be created correctly with proper properties
- Tests ensure exception classes work correctly with different parameters
- Tests validate router configuration and route definitions
- Toast service tests verify method existence (actual toast functionality would require widget testing)
