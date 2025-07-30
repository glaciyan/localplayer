import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/core/network/no_connection_exception.dart';

void main() {
  group('NoConnectionException', () {
    test('should create NoConnectionException with default message', () {
      // Arrange & Act
      final exception = NoConnectionException();

      // Assert
      expect(exception, isA<NoConnectionException>());
      expect(exception, isA<Exception>());
      expect(exception.message, equals('No internet connection'));
    });

    test('should create NoConnectionException with custom message', () {
      // Arrange
      const message = 'Custom connection error message';

      // Act
      final exception = NoConnectionException(message);

      // Assert
      expect(exception, isA<NoConnectionException>());
      expect(exception.message, equals(message));
    });

    test('should have correct toString representation', () {
      // Arrange
      const message = 'Test connection error';

      // Act
      final exception = NoConnectionException(message);

      // Assert
      expect(exception.toString(), equals('NoConnectionException: $message'));
    });

    test('should have correct toString with default message', () {
      // Arrange & Act
      final exception = NoConnectionException();

      // Assert
      expect(exception.toString(), equals('NoConnectionException: No internet connection'));
    });
  });
}
