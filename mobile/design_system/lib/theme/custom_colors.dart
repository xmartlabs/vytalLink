// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.textColor,
    required this.info,
    required this.success,
    required this.warning,
    required this.danger,
    required this.shadow,
  }) : super();

  final Color? textColor;
  final Color? info;
  final Color? success;
  final Color? warning;
  final Color? danger;
  final Color? shadow;

  static CustomColors getCustomColors() => const CustomColors(
        textColor: MaterialColor(
          0xff1e293b,
          <int, Color>{
            100: Color(0xffffffff),
            200: Color(0xff94a3b8),
            300: Color(0xff64748b),
            400: Color(0xff1e293b),
            500: Color(0xff0f172a),
          },
        ),
        info: MaterialColor(
          0xff6366f1,
          <int, Color>{
            100: Color(0xffe0e7ff),
            200: Color(0xffc7d2fe),
            300: Color(0xff6366f1),
            400: Color(0xff4f46e5),
            500: Color(0xff312e81),
          },
        ),
        success: MaterialColor(
          0xff10b981,
          <int, Color>{
            100: Color(0xffd1fae5),
            200: Color(0xffa7f3d0),
            300: Color(0xff10b981),
            400: Color(0xff059669),
            500: Color(0xff047857),
          },
        ),
        warning: MaterialColor(
          0xfffbbf24,
          <int, Color>{
            100: Color(0xfffef3c7),
            200: Color(0xfffde68a),
            300: Color(0xfffbbf24),
            400: Color(0xfff59e0b),
            500: Color(0xffd97706),
          },
        ),
        danger: MaterialColor(
          0xffef4444,
          <int, Color>{
            100: Color(0xfffecaca),
            200: Color(0xfffca5a5),
            300: Color(0xffef4444),
            400: Color(0xffdc2626),
            500: Color(0xffb91c1c),
          },
        ),
        shadow: Color(0x1a000000),
      );

  @override
  CustomColors copyWith({MaterialColor? primary}) =>
      CustomColors.getCustomColors();

  @override
  CustomColors lerp(CustomColors? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      textColor: Color.lerp(textColor, other.textColor, t),
      info: Color.lerp(info, other.info, t),
      success: Color.lerp(success, other.success, t),
      warning: Color.lerp(warning, other.warning, t),
      danger: Color.lerp(danger, other.danger, t),
      shadow: Color.lerp(shadow, other.shadow, t),
    );
  }

  @override
  Object get type => CustomColors;
}
