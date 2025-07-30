import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:localplayer/core/entities/hex_color.dart';

void main() {
  group('HexColor', () {
    test('should create HexColor from 6-digit hex string', () {
      // Arrange & Act
      final color = HexColor('FF0000');

      // Assert
      expect(color, isA<HexColor>());
      expect(color, isA<Color>());
      expect(color.value, equals(0xFFFF0000));
    });

    test('should create HexColor from 6-digit hex string with #', () {
      // Arrange & Act
      final color = HexColor('#FF0000');

      // Assert
      expect(color, isA<HexColor>());
      expect(color, isA<Color>());
      expect(color.value, equals(0xFFFF0000));
    });

    test('should create HexColor from 8-digit hex string', () {
      // Arrange & Act
      final color = HexColor('FFFF0000');

      // Assert
      expect(color, isA<HexColor>());
      expect(color, isA<Color>());
      expect(color.value, equals(0xFFFF0000));
    });

    test('should create HexColor from 8-digit hex string with #', () {
      // Arrange & Act
      final color = HexColor('#FFFF0000');

      // Assert
      expect(color, isA<HexColor>());
      expect(color, isA<Color>());
      expect(color.value, equals(0xFFFF0000));
    });

    test('should handle lowercase hex strings', () {
      // Arrange & Act
      final color = HexColor('#ff0000');

      // Assert
      expect(color, isA<HexColor>());
      expect(color, isA<Color>());
      expect(color.value, equals(0xFFFF0000));
    });

    test('should handle mixed case hex strings', () {
      // Arrange & Act
      final color = HexColor('#Ff00Ff');

      // Assert
      expect(color, isA<HexColor>());
      expect(color, isA<Color>());
      expect(color.value, equals(0xFFFF00FF));
    });

    test('should work with different colors', () {
      // Test green
      final green = HexColor('#00FF00');
      expect(green.value, equals(0xFF00FF00));

      // Test blue
      final blue = HexColor('#0000FF');
      expect(blue.value, equals(0xFF0000FF));

      // Test white
      final white = HexColor('#FFFFFF');
      expect(white.value, equals(0xFFFFFFFF));

      // Test black
      final black = HexColor('#000000');
      expect(black.value, equals(0xFF000000));
    });
  });
}
