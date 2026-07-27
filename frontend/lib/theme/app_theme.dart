import 'package:flutter/material.dart';

/// AppTheme defines the LLC "Technical Luxury" design system tokens and ThemeData
/// as specified in DESIGN.md & PRODUCT.md.
class AppTheme {
  // Brand Color Palette
  static const Color backgroundVoid = Color(0xFF0D1117);
  static const Color surfaceDark = Color(0xFF161B22);
  static const Color surfaceElevated = Color(0xFF21262D);
  static const Color glassBorder = Color(0x1FFFFFFF); // rgba(255, 255, 255, 0.12)

  static const Color thermalCore = Color(0xFFFF3B30);
  static const Color thermalCorona = Color(0xFFFF9500);
  static const Color cyanSignal = Color(0xFF58A6FF);

  static const Color textPrimary = Color(0xFFF0F6FC);
  static const Color textSecondary = Color(0xFF8B949E);

  /// Main dark theme configuration implementing Technical Luxury dark glass domain
  static ThemeData get darkTheme {
    final baseScheme = ColorScheme.dark(
      surface: surfaceDark,
      onSurface: textPrimary,
      primary: thermalCore,
      onPrimary: Colors.white,
      primaryContainer: surfaceElevated,
      onPrimaryContainer: thermalCorona,
      secondary: cyanSignal,
      onSecondary: backgroundVoid,
      secondaryContainer: Color(0x1F58A6FF),
      onSecondaryContainer: cyanSignal,
      error: thermalCore,
      onError: Colors.white,
      outline: glassBorder,
      outlineVariant: Color(0x0DFFFFFF),
      surfaceContainerLow: surfaceDark,
      surfaceContainer: surfaceElevated,
      surfaceContainerHigh: Color(0xFF2D333B),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundVoid,
      colorScheme: baseScheme,

      // Typography
      fontFamily: 'Montserrat',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Montserrat', fontSize: 32, fontWeight: FontWeight.w800, color: textPrimary, height: 1.2, letterSpacing: -0.5),
        headlineMedium: TextStyle(fontFamily: 'Montserrat', fontSize: 24, fontWeight: FontWeight.w700, color: textPrimary, height: 1.3),
        titleLarge: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary, height: 1.4),
        titleMedium: TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary, height: 1.4),
        bodyLarge: TextStyle(fontFamily: 'Open Sans', fontSize: 16, fontWeight: FontWeight.w400, color: textPrimary, height: 1.5),
        bodyMedium: TextStyle(fontFamily: 'Open Sans', fontSize: 14, fontWeight: FontWeight.w400, color: textPrimary, height: 1.5),
        bodySmall: TextStyle(fontFamily: 'Open Sans', fontSize: 12, fontWeight: FontWeight.w400, color: textSecondary, height: 1.4),
        labelLarge: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 13, fontWeight: FontWeight.w500, color: textSecondary, letterSpacing: 0.8),
        labelMedium: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 11, fontWeight: FontWeight.w500, color: textSecondary, letterSpacing: 0.8),
      ),

      // Component Themes
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundVoid,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),

      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: glassBorder, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundVoid,
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textSecondary),
        prefixIconColor: textSecondary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: glassBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: glassBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: thermalCore, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: thermalCore, width: 1),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: thermalCore,
          foregroundColor: textPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: glassBorder, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: thermalCore,
        foregroundColor: textPrimary,
        elevation: 4,
        shape: CircleBorder(),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Color(0xE6161B22),
        indicatorColor: surfaceElevated,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: thermalCorona);
          }
          return const IconThemeData(color: textSecondary);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            );
          }
          return const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          );
        }),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: surfaceDark,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: glassBorder, width: 1),
        ),
        titleTextStyle: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: glassBorder,
        thickness: 1,
      ),
    );
  }
}
