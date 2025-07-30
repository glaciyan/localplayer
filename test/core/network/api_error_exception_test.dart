import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/core/network/api_error_exception.dart';

void main() {
  group('ApiErrorException', () {
    test('should create ApiErrorException with default values', () {
      // Arrange & Act
      final exception = ApiErrorException();

      // Assert
      expect(exception, isA<ApiErrorException>());
      expect(exception, isA<Exception>());
      expect(exception.message, equals('Unexpected Error'));
      expect(exception.code, equals('unknown/error'));
    });

    test('should create ApiErrorException with custom message', () {
      // Arrange
      const message = 'Custom error message';

      // Act
      final exception = ApiErrorException(message);

      // Assert
      expect(exception, isA<ApiErrorException>());
      expect(exception.message, equals(message));
      expect(exception.code, equals('unknown/error'));
    });

    test('should create ApiErrorException with custom message and code', () {
      // Arrange
      const message = 'Custom error message';
      const code = 'custom/error';

      // Act
      final exception = ApiErrorException(message, code);

      // Assert
      expect(exception, isA<ApiErrorException>());
      expect(exception.message, equals(message));
      expect(exception.code, equals(code));
    });

    test('should have correct toString representation', () {
      // Arrange
      const message = 'Test error message';
      const code = 'test/error';

      // Act
      final exception = ApiErrorException(message, code);

      // Assert
      expect(exception.toString(), equals('ApiErrorException: $code $message'));
    });

    test('should have correct toString with default values', () {
      // Arrange & Act
      final exception = ApiErrorException();

      // Assert
      expect(exception.toString(), equals('ApiErrorException: unknown/error Unexpected Error'));
    });
  });
}
