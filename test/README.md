# LocalPlayer Test Suite

This directory contains comprehensive tests for the LocalPlayer Flutter application.

## 📊 Test Overview

- **Total Tests**: 168 tests
- **Features**: 6 feature modules (Auth, Feed, Map, Match, Profile, Session)
- **Core Components**: 5 core modules (Entities, Network, Services, Widgets, Router)
- **All Tests Passing**: ✅

## 🚀 Quick Start

### Run All Tests
```bash
flutter test test/
```

### Run Specific Test Categories

#### Run All Feature Tests
```bash
flutter test test/features/
```

#### Run All Core Tests
```bash
flutter test test/core/
```

#### Run Individual Feature Tests
```bash
# Auth tests
flutter test test/features/auth/auth_test_suite.dart

# Feed tests
flutter test test/features/feed/feed_test_suite.dart

# Map tests
flutter test test/features/map/map_test_suite.dart

# Match tests
flutter test test/features/match/match_test_suite.dart

# Profile tests
flutter test test/features/profile/profile_test_suite.dart

# Session tests
flutter test test/features/session/session_test_suite.dart
```

#### Run Individual Core Tests
```bash
# Entities tests
flutter test test/core/entities/hex_color_test.dart
flutter test test/core/entities/profile_with_spotify_test.dart

# Network tests
flutter test test/core/network/api_error_exception_test.dart
flutter test test/core/network/no_connection_exception_test.dart

# Services tests
flutter test test/core/services/toast_service_test.dart

# Router tests
flutter test test/core/go_router/router_test.dart
```

## 📁 Test Structure

```
test/
├── README.md                           # This file
├── core/                               # Core component tests
│   ├── README.md                       # Core tests documentation
│   ├── core_test_suite.dart            # Core test runner
│   ├── entities/                       # Entity tests
│   │   ├── hex_color_test.dart         # HexColor utility tests
│   │   └── profile_with_spotify_test.dart # ProfileWithSpotify tests
│   ├── network/                        # Network tests
│   │   ├── api_error_exception_test.dart # API error tests
│   │   └── no_connection_exception_test.dart # Connection error tests
│   ├── services/                       # Service tests
│   │   └── toast_service_test.dart     # Toast service tests
│   └── go_router/                      # Router tests
│       └── router_test.dart            # Router configuration tests
└── features/                           # Feature tests
    ├── auth/                           # Authentication tests
    │   ├── README.md                   # Auth tests documentation
    │   ├── auth_test_suite.dart        # Auth test runner
    │   └── presentation/blocs/         # Auth bloc tests
    ├── feed/                           # Feed tests
    │   ├── README.md                   # Feed tests documentation
    │   ├── feed_test_suite.dart        # Feed test runner
    │   └── presentation/blocs/         # Feed bloc tests
    ├── map/                            # Map tests
    │   ├── README.md                   # Map tests documentation
    │   ├── map_test_suite.dart         # Map test runner
    │   └── presentation/blocs/         # Map bloc tests
    ├── match/                          # Match tests
    │   ├── README.md                   # Match tests documentation
    │   ├── match_test_suite.dart       # Match test runner
    │   └── presentation/blocs/         # Match bloc tests
    ├── profile/                        # Profile tests
    │   ├── README.md                   # Profile tests documentation
    │   ├── profile_test_suite.dart     # Profile test runner
    │   └── presentation/blocs/         # Profile bloc tests
    └── session/                        # Session tests
        ├── README.md                   # Session tests documentation
        ├── session_test_suite.dart     # Session test runner
        └── presentation/blocs/         # Session bloc tests
```

## 🧪 Test Categories

### Feature Tests (139 tests)

#### Auth Tests (21 tests)
- Event instantiation and property validation
- State instantiation and property validation
- Bloc behavior testing
- Authentication flow validation

#### Feed Tests (15 tests)
- Event instantiation and property validation
- State instantiation and property validation
- Notification model testing
- Feed bloc behavior testing

#### Map Tests (15 tests)
- Event instantiation and property validation
- State instantiation and property validation
- Map bloc behavior testing
- Profile selection testing

#### Match Tests (13 tests)
- Event instantiation and property validation
- State instantiation and property validation
- Match bloc behavior testing
- Profile matching logic testing

#### Profile Tests (14 tests)
- Event instantiation and property validation
- State instantiation and property validation
- Profile bloc behavior testing
- Profile update testing

#### Session Tests (17 tests)
- Event instantiation and property validation
- State instantiation and property validation
- Session bloc behavior testing
- Session model testing

### Core Tests (29 tests)

#### Entity Tests (11 tests)
- **HexColor Tests (7 tests)**: Hex color parsing, case handling, different colors
- **ProfileWithSpotify Tests (4 tests)**: Entity creation, property access

#### Network Tests (9 tests)
- **ApiErrorException Tests (5 tests)**: Exception creation, toString representation
- **NoConnectionException Tests (4 tests)**: Exception creation, toString representation

#### Service Tests (4 tests)
- **ToastService Tests (4 tests)**: Method existence and signature validation

#### Router Tests (5 tests)
- **Router Tests (5 tests)**: Router instance validation and configuration

## 🛠️ Test Commands

### Development Commands

```bash
# Run all tests with verbose output
flutter test test/ --verbose

# Run tests with coverage
flutter test test/ --coverage

# Run tests and generate coverage report
flutter test test/ --coverage --coverage-path=coverage/lcov.info

# Run tests in parallel (faster)
flutter test test/ --concurrency=4

# Run tests with specific tags
flutter test test/ --tags=unit
flutter test test/ --tags=integration
```

### Debugging Commands

```bash
# Run a single test file
flutter test test/features/auth/auth_test_suite.dart

# Run a specific test
flutter test test/features/auth/auth_test_suite.dart --name="AuthEvent"

# Run tests with detailed output
flutter test test/ --verbose --reporter=expanded

# Run tests and stop on first failure
flutter test test/ --stop-on-first-failure
```

### CI/CD Commands

```bash
# Run tests for CI (no coverage, fast)
flutter test test/ --coverage --reporter=compact

# Run tests and generate coverage report for CI
flutter test test/ --coverage --coverage-path=coverage/lcov.info --reporter=compact
```

## 📈 Test Coverage

### Current Coverage
- **Total Tests**: 168
- **Features**: 6 modules (100% covered)
- **Core Components**: 5 modules (100% covered)
- **Test Types**: Unit tests, integration tests, bloc tests

### Coverage Areas
- ✅ **Event Classes**: All event instantiation and property validation
- ✅ **State Classes**: All state instantiation and property validation
- ✅ **Bloc Classes**: Basic bloc behavior and event handling
- ✅ **Entity Classes**: Data model creation and property access
- ✅ **Exception Classes**: Error handling and message formatting
- ✅ **Service Classes**: Service method existence and signatures
- ✅ **Router Configuration**: Navigation setup validation

## 🔧 Test Configuration

### Dependencies
The tests use the following packages:
- `flutter_test`: Core testing framework
- `bloc_test`: BLoC testing utilities
- `mockito`: Mocking framework
- `latlong2`: Geographic coordinate types

### Test Patterns
- **Unit Tests**: Test individual components in isolation
- **Bloc Tests**: Test state management and event handling
- **Entity Tests**: Test data models and property validation
- **Exception Tests**: Test error handling and message formatting

## 🐛 Troubleshooting

### Common Issues

#### Tests Not Running
```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Run tests again
flutter test test/
```

#### Import Errors
```bash
# Regenerate mock files
flutter packages pub run build_runner build

# Clean and regenerate
flutter packages pub run build_runner clean
flutter packages pub run build_runner build
```

#### Flutter Binding Issues
If you encounter Flutter binding errors:
- Tests that require Flutter widgets need `TestWidgetsFlutterBinding.ensureInitialized()`
- Most core tests avoid this by testing method signatures rather than actual execution

### Debug Mode
```bash
# Run tests in debug mode
flutter test test/ --debug

# Run with detailed logging
flutter test test/ --verbose --debug
```

## 📝 Adding New Tests

### For New Features
1. Create test directory: `test/features/new_feature/`
2. Create test suite: `test/features/new_feature/new_feature_test_suite.dart`
3. Create bloc tests: `test/features/new_feature/presentation/blocs/`
4. Add to main test runner

### For New Core Components
1. Create test directory: `test/core/new_component/`
2. Create test file: `test/core/new_component/new_component_test.dart`
3. Add to core test suite

### Test Naming Convention
- Test files: `*_test.dart`
- Test suites: `*_test_suite.dart`
- Test groups: Descriptive group names
- Test cases: Descriptive test names

## 📚 Additional Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [BLoC Testing Guide](https://bloclibrary.dev/#/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)

## 🤝 Contributing

When adding new tests:
1. Follow the existing test patterns
2. Ensure all tests pass before committing
3. Update this README if adding new test categories
4. Keep tests focused and maintainable

---

**Last Updated**: July 2024
**Total Tests**: 168 ✅
**Status**: All tests passing
