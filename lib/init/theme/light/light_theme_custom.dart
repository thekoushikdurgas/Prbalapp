import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part '../../../constants/theme/light_constants.dart';

class LightThemeCustom {
  late ThemeData theme;

  LightThemeCustom() {
    theme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: LightThemeColors._primaryColor,
        primaryContainer: LightThemeColors._primaryVariant,
        secondary: LightThemeColors._secondary,
        secondaryContainer: LightThemeColors._secondaryVariant,
        surface: LightThemeColors._surface,
        surfaceContainerHighest: LightThemeColors._surfaceVariant,
        error: LightThemeColors._error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: LightThemeColors._textPrimary,
        onError: Colors.white,
        outline: LightThemeColors._border,
        shadow: LightThemeColors._shadow,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: LightThemeColors._appBarBackground,
        foregroundColor: LightThemeColors._appBarForeground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: LightThemeColors._shadow,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: LightThemeColors._background,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: LightThemeColors._textPrimary,
        ),
        iconTheme: const IconThemeData(
          color: LightThemeColors._textPrimary,
          size: 24,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: LightThemeColors._cardBackground,
        elevation: 2,
        shadowColor: LightThemeColors._shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: LightThemeColors._primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: LightThemeColors._shadow,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LightThemeColors._inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: LightThemeColors._inputBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: LightThemeColors._inputBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: LightThemeColors._inputFocused,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: LightThemeColors._error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: LightThemeColors._error,
            width: 2,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(
          color: LightThemeColors._textTertiary,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          color: LightThemeColors._textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: LightThemeColors._surface,
        selectedItemColor: LightThemeColors._primaryColor,
        unselectedItemColor: LightThemeColors._textTertiary,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: LightThemeColors._textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: LightThemeColors._textPrimary,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: LightThemeColors._textPrimary,
          letterSpacing: -0.5,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: LightThemeColors._textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: LightThemeColors._textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: LightThemeColors._textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: LightThemeColors._textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: LightThemeColors._textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: LightThemeColors._textSecondary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: LightThemeColors._textPrimary,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: LightThemeColors._textSecondary,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: LightThemeColors._textTertiary,
          height: 1.4,
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: LightThemeColors._divider,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: LightThemeColors._textSecondary,
        size: 24,
      ),

      // Primary Icon Theme
      primaryIconTheme: const IconThemeData(
        color: LightThemeColors._primaryColor,
        size: 24,
      ),
    );
  }
}
