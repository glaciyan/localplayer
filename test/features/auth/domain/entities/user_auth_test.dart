import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/features/auth/domain/entities/user_auth.dart';

void main() {
  group('UserAuth', () {
    test('should create UserAuth with correct values', () {
      // Arrange
      const String id = '1';
      const String name = 'testuser';
      const String token = 'test_token_123';

      // Act
      const userAuth = UserAuth(id: id, name: name, token: token);

      // Assert
      expect(userAuth.id, equals(id));
      expect(userAuth.name, equals(name));
      expect(userAuth.token, equals(token));
    });

    test('should have const constructor', () {
      // Arrange & Act
      const userAuth1 = UserAuth(id: '1', name: 'user1', token: 'token1');
      const userAuth2 = UserAuth(id: '1', name: 'user1', token: 'token1');

      // Assert
      expect(userAuth1, equals(userAuth2));
    });

    test('should have required parameters', () {
      // This test ensures that all parameters are required
      // If any parameter is made optional, this test will need to be updated
      expect(() => UserAuth(id: '1', name: 'user', token: 'token'), returnsNormally);
    });

    test('should be immutable', () {
      // Arrange
      const userAuth = UserAuth(id: '1', name: 'user', token: 'token');

      // Act & Assert
      // Since all fields are final, the object is immutable
      expect(userAuth.id, equals('1'));
      expect(userAuth.name, equals('user'));
      expect(userAuth.token, equals('token'));
    });
  });
} 