import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/features/auth/domain/entities/login_token.dart';

void main() {
  group('LoginToken', () {
    test('should create LoginToken with correct token', () {
      // Arrange
      const String token = 'test_token_123';

      // Act
      final LoginToken loginToken = LoginToken(token: token);

      // Assert
      expect(loginToken.token, equals(token));
    });

    test('should create LoginToken from JSON', () {
      // Arrange
      const String token = 'test_token_123';
      final Map<String, dynamic> json = <String, dynamic>{
        'token': token,
      };

      // Act
      final LoginToken loginToken = LoginToken.fromJson(json);

      // Assert
      expect(loginToken.token, equals(token));
    });

    test('should throw exception when JSON is missing token', () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act & Assert
      expect(
        () => LoginToken.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });

    test('should throw exception when JSON token is not a string', () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        'token': 123,
      };

      // Act & Assert
      expect(
        () => LoginToken.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });

    test('should handle empty token string', () {
      // Arrange
      const String token = '';
      final Map<String, dynamic> json = <String, dynamic>{
        'token': token,
      };

      // Act
      final LoginToken loginToken = LoginToken.fromJson(json);

      // Assert
      expect(loginToken.token, equals(token));
    });

    test('should be immutable', () {
      // Arrange
      final LoginToken loginToken = LoginToken(token: 'test_token');

      // Act & Assert
      // Since the field is final, the object is immutable
      expect(loginToken.token, equals('test_token'));
    });
  });
} 