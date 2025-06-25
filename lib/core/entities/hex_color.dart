import 'package:flutter/material.dart';

/// A Color subclass that accepts hex strings like "#aabbcc" or "ffaabbcc".
class HexColor extends Color {
  /// [hexString] can be in the formats "aabbcc", "ffaabbcc", with or without a leading “#”.
  HexColor(final String hexString) : super(_parseHex(hexString));

  static int _parseHex(String hex) {
    // Remove any leading “#” and make uppercase for consistency
    hex = hex.replaceAll('#', '').toUpperCase();
    // If only RRGGBB is provided, default the alpha to 'FF'
    if (hex.length == 6) hex = 'FF$hex';
    // Must now be AARRGGBB
    return int.parse(hex, radix: 16);
  }
}
