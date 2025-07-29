# Auth Feature Tests

This directory contains comprehensive unit tests for the authentication feature of the LocalPlayer app.

## Test Structure

```
test/features/auth/
├── README.md                           # This file
├── auth_test_suite.dart                # Test suite runner
├── domain/
│   └── entities/
│       ├── user_auth_test.dart         # UserAuth entity tests
│       └── login_token_test.dart       # LoginToken entity tests
├── data/
│   ├── repositories/
│   │   └── auth_repository_test.dart   # AuthRepository tests
│   └── datasources/
│       └── auth_remote_data_source_test.dart # AuthRemoteDataSource tests
└── presentation/
    └── blocs/
        ├── auth_bloc_test.dart         # AuthBloc tests
        ├── auth_event_test.dart        # AuthEvent tests
        └── auth_state_test.dart        # AuthState tests
```

## Test Coverage

### Domain Layer
- **UserAuth**: Tests for user authentication entity
- **LoginToken**: Tests for login token entity and JSON serialization

### Data Layer
- **AuthRepository**: Tests for repository pattern implementation
- **AuthRemoteDataSource**: Tests for API client interactions

### Presentation Layer
- **AuthBloc**: Comprehensive tests for business logic and state management
- **AuthEvent**: Tests for all authentication events
- **AuthState**: Tests for all authentication states

## Running Tests

### Run All Auth Tests
```bash
flutter test test/features/auth/auth_test_suite.dart
```

### Run Individual Test Files
```bash
# Domain tests
flutter test test/features/auth/domain/entities/user_auth_test.dart
flutter test test/features/auth/domain/entities/login_token_test.dart

# Data layer tests
flutter test test/features/auth/data/repositories/auth_repository_test.dart
flutter test test/features/auth/data/datasources/auth_remote_data_source_test.dart

# Presentation layer tests
flutter test test/features/auth/presentation/blocs/auth_bloc_test.dart
flutter test test/features/auth/presentation/blocs/auth_event_test.dart
flutter test test/features/auth/presentation/blocs/auth_state_test.dart
```

### Run with Coverage
```bash
flutter test --coverage test/features/auth/
```

## Test Features

### AuthBloc Tests
- ✅ Sign in success flow (location → auth → presence → storage)
- ✅ Sign in failure scenarios (geolocator, auth, presence errors)
- ✅ Sign up success and failure flows
- ✅ Find me functionality with token validation
- ✅ All event handlers and state transitions
- ✅ Error handling and edge cases

### Repository Tests
- ✅ Method delegation to data source
- ✅ Error propagation
- ✅ Parameter passing

### Data Source Tests
- ✅ API endpoint calls with correct parameters
- ✅ HTTP method and header validation
- ✅ Error handling for network failures

### Entity Tests
- ✅ Object creation and property access
- ✅ JSON serialization/deserialization
- ✅ Error handling for invalid data
- ✅ Immutability validation

## Dependencies

The tests use the following testing libraries:
- `flutter_test`: Core Flutter testing framework
- `bloc_test`: For testing BLoC state management
- `mockito`: For creating mocks and stubs
- `build_runner`: For generating mock classes

## Mock Generation

Before running tests that use mocks, generate the mock files:

```bash
flutter packages pub run build_runner build
```

This will generate the `.mocks.dart` files needed for the tests.

## Test Patterns

### Arrange-Act-Assert
All tests follow the AAA pattern:
- **Arrange**: Set up test data and mocks
- **Act**: Execute the method being tested
- **Assert**: Verify the expected outcomes

### Bloc Testing
BLoC tests use `blocTest` to verify:
- State transitions
- Event handling
- Side effects
- Error scenarios

### Mock Verification
Tests verify that:
- Correct methods are called
- Parameters are passed correctly
- Methods are called the expected number of times
- Methods are not called when they shouldn't be

## Coverage Goals

- **Domain Layer**: 100% coverage
- **Data Layer**: 100% coverage  
- **Presentation Layer**: 95%+ coverage
- **Error Scenarios**: All major error paths covered
- **Edge Cases**: Boundary conditions and null handling

## Maintenance

When adding new features to the auth module:
1. Add corresponding tests for new functionality
2. Update existing tests if interfaces change
3. Ensure all error paths are covered
4. Run the full test suite to verify no regressions 