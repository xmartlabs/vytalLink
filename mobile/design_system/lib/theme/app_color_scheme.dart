// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';

// Colors name extracted from https://www.color-name.com
@immutable
class AppColorScheme extends ColorScheme {
  @override
  final Color onPrimary;
  @override
  final MaterialColor primary;
  @override
  final MaterialColor secondary;
  @override
  final MaterialColor surface;
  @override
  final MaterialColor onSurface;

  AppColorScheme({
    required ColorScheme colorScheme,
    required this.onPrimary,
    required this.onSurface,
    required this.secondary,
    required this.primary,
    required this.surface,
  }) : super(
          brightness: colorScheme.brightness,
          primary: colorScheme.primary,
          onPrimary: colorScheme.onPrimary,
          primaryContainer: colorScheme.primaryContainer,
          onPrimaryContainer: colorScheme.onPrimaryContainer,
          secondary: colorScheme.secondary,
          onSecondary: colorScheme.onSecondary,
          secondaryContainer: colorScheme.secondaryContainer,
          onSecondaryContainer: colorScheme.onSecondaryContainer,
          tertiary: colorScheme.tertiary,
          onTertiary: colorScheme.onTertiary,
          tertiaryContainer: colorScheme.tertiaryContainer,
          onTertiaryContainer: colorScheme.onTertiaryContainer,
          error: colorScheme.error,
          onError: colorScheme.onError,
          errorContainer: colorScheme.errorContainer,
          onErrorContainer: colorScheme.onErrorContainer,
          surface: colorScheme.surface,
          onSurface: colorScheme.onSurface,
          surfaceContainerHighest: colorScheme.surfaceContainerHighest,
          onSurfaceVariant: colorScheme.onSurfaceVariant,
          outline: colorScheme.outline,
          outlineVariant: colorScheme.outlineVariant,
          shadow: colorScheme.shadow,
          scrim: colorScheme.scrim,
          inverseSurface: colorScheme.inverseSurface,
          onInverseSurface: colorScheme.onInverseSurface,
          inversePrimary: colorScheme.inversePrimary,
          surfaceTint: colorScheme.surfaceTint,
        );

  static AppColorScheme getDefaultColorScheme() => AppColorScheme(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: const Color(0xff6366f1),
          primaryContainer: const Color(0xff6366f1),
          onSecondary: const Color(0xff1e293b),
          error: const MaterialColor(
            0xfff4642c,
            <int, Color>{
              100: Color(0xfffeebd4),
              200: Color(0xfffbb37f),
              300: Color(0xfff4642c),
              400: Color(0xffd74824),
              500: Color(0xff750908),
            },
          ),
          onError: Colors.white,
          onSurface: const Color(0xff64748b),
          surface: const Color(0xfff1f5f9),
        ),
        primary: const MaterialColor(
          0xff6366f1,
          <int, Color>{
            50: Color(0xffeef2ff),
            100: Color(0xffe0e7ff),
            200: Color(0xffc7d2fe),
            300: Color(0xffa5b4fc),
            400: Color(0xff818cf8),
            500: Color(0xff6366f1),
            600: Color(0xff4f46e5),
            700: Color(0xff4338ca),
            800: Color(0xff3730a3),
            900: Color(0xff312e81),
            1000: Color(0xff1e1b4b),
          },
        ),
        onPrimary: const MaterialColor(
          0xff1e293b,
          <int, Color>{
            100: Color(0xffffffff),
            200: Color(0xff94a3b8),
            300: Color(0xff64748b),
            400: Color(0xff1e293b),
            500: Color(0xff0f172a),
          },
        ),
        secondary: const MaterialColor(
          0xff10b981,
          <int, Color>{
            50: Color(0xffecfdf5),
            100: Color(0xffd1fae5),
            200: Color(0xffa7f3d0),
            300: Color(0xff6ee7b7),
            400: Color(0xff34d399),
            500: Color(0xff10b981),
            600: Color(0xff059669),
            700: Color(0xff047857),
            800: Color(0xff065f46),
            900: Color(0xff064e3b),
            1000: Color(0xff022c22),
          },
        ),
        surface: const MaterialColor(
          0xfff1f5f9,
          <int, Color>{
            50: Color(0xffffffff),
            100: Color(0xfff8fafc),
            200: Color(0xfff1f5f9),
            300: Color(0xffe2e8f0),
            400: Color(0xffcbd5e1),
            500: Color(0xff94a3b8),
          },
        ),
        onSurface: const MaterialColor(
          0xff64748b,
          <int, Color>{
            100: Color(0xffffffff),
            200: Color(0xff94a3b8),
            300: Color(0xff64748b),
            400: Color(0xff1e293b),
            500: Color(0xff0f172a),
          },
        ),
      );
}

extension MaterialExtensions on MaterialColor {
  Color get shade1000 => this[1000]!;
}
