import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/core/network/no_connection_exception.dart';

void main() {
  group('NoConnectionException', () {
    test('should create NoConnectionException with default message', () {
      // Arrange & Act
      final NoConnectionException exception = NoConnectionException();

      // Assert
      expect(exception, isA<NoConnectionException>());
      expect(exception, isA<Exception>());
      expect(exception.message, equals('No internet connection'));
    });

    test('should create NoConnectionException with custom message', () {
      // Arrange
      const String message = 'Custom connection error message';

      // Act
      final NoConnectionException exception = NoConnectionException(message);

      // Assert
      expect(exception, isA<NoConnectionException>());
      expect(exception.message, equals(message));
    });

    test('should have correct toString representation', () {
      // Arrange
      const String message = 'Test connection error';

      // Act
      final NoConnectionException exception = NoConnectionException(message);

      // Assert
      expect(exception.toString(), equals('NoConnectionException: $message'));
    });

    test('should have correct toString with default message', () {
      // Arrange & Act
      final NoConnectionException exception = NoConnectionException();

      // Assert
      expect(exception.toString(), equals('NoConnectionException: No internet connection'));
    });
  });
}
