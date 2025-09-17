import 'dart:math';

import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color getShade(int shade) {
    if (this is MaterialColor) {
      final materialColor = this as MaterialColor;
      final shadeColor = materialColor[shade];
      if (shadeColor != null) {
        return shadeColor;
      }
      final availableShades = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
      final int closestShade = availableShades.reduce(
        (a, b) => (shade - a).abs() < (shade - b).abs() ? a : b,
      );
      return materialColor[closestShade] ?? materialColor;
    }
    return _generateMaterialColor()[shade] ?? this;
  }

  MaterialColor _generateMaterialColor() => MaterialColor(toARGB32(), {
        50: _tintColor(0.9),
        100: _tintColor(0.8),
        200: _tintColor(0.6),
        300: _tintColor(0.4),
        400: _tintColor(0.2),
        500: this,
        600: _shadeColor(0.1),
        700: _shadeColor(0.2),
        800: _shadeColor(0.3),
        900: _shadeColor(0.4),
      });

  int _tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  Color _tintColor(double factor) => Color.fromRGBO(
        _tintValue((r * 255.0).round() & 0xff, factor),
        _tintValue((g * 255.0).round() & 0xff, factor),
        _tintValue((b * 255.0).round() & 0xff, factor),
        1,
      );

  int _shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));

  Color _shadeColor(double factor) => Color.fromRGBO(
        _shadeValue((r * 255.0).round() & 0xff, factor),
        _shadeValue((g * 255.0).round() & 0xff, factor),
        _shadeValue((b * 255.0).round() & 0xff, factor),
        1,
      );
}
