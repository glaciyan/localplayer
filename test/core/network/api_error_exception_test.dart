import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/core/network/api_error_exception.dart';

void main() {
  group('ApiErrorException', () {
    test('should create ApiErrorException with default values', () {
      // Arrange & Act
      final ApiErrorException exception = ApiErrorException();

      // Assert
      expect(exception, isA<ApiErrorException>());
      expect(exception, isA<Exception>());
      expect(exception.message, equals('Unexpected Error'));
      expect(exception.code, equals('unknown/error'));
    });

    test('should create ApiErrorException with custom message', () {
      // Arrange
      const String message = 'Custom error message';

      // Act
      final ApiErrorException exception = ApiErrorException(message);

      // Assert
      expect(exception, isA<ApiErrorException>());
      expect(exception.message, equals(message));
      expect(exception.code, equals('unknown/error'));
    });

    test('should create ApiErrorException with custom message and code', () {
      // Arrange
      const String message = 'Custom error message';
      const String code = 'custom/error';

      // Act
      final ApiErrorException exception = ApiErrorException(message, code);

      // Assert
      expect(exception, isA<ApiErrorException>());
      expect(exception.message, equals(message));
      expect(exception.code, equals(code));
    });

    test('should have correct toString representation', () {
      // Arrange
      const String message = 'Test error message';
      const String code = 'test/error';

      // Act
      final ApiErrorException exception = ApiErrorException(message, code);

      // Assert
      expect(exception.toString(), equals('ApiErrorException: $code $message'));
    });

    test('should have correct toString with default values', () {
      // Arrange & Act
      final ApiErrorException exception = ApiErrorException();

      // Assert
      expect(exception.toString(), equals('ApiErrorException: unknown/error Unexpected Error'));
    });
  });
}
