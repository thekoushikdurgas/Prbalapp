import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part '../../constants/theme/dark_constants.dart';

class DarkThemeCustom {
  late ThemeData theme;

  DarkThemeCustom() {
    theme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: DarkThemeColors._primaryColor,
        primaryContainer: DarkThemeColors._primaryVariant,
        secondary: DarkThemeColors._secondary,
        secondaryContainer: DarkThemeColors._secondaryVariant,
        surface: DarkThemeColors._surface,
        surfaceContainerHighest: DarkThemeColors._surfaceVariant,
        error: DarkThemeColors._error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: DarkThemeColors._textPrimary,
        onError: Colors.white,
        outline: DarkThemeColors._border,
        shadow: DarkThemeColors._shadow,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: DarkThemeColors._appBarBackground,
        foregroundColor: DarkThemeColors._appBarForeground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: DarkThemeColors._shadow,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: DarkThemeColors._background,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: DarkThemeColors._textPrimary,
        ),
        iconTheme: const IconThemeData(
          color: DarkThemeColors._textPrimary,
          size: 24,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: DarkThemeColors._cardBackground,
        elevation: 4,
        shadowColor: DarkThemeColors._shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DarkThemeColors._primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: DarkThemeColors._shadow,
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
        fillColor: DarkThemeColors._inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: DarkThemeColors._inputBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: DarkThemeColors._inputBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: DarkThemeColors._inputFocused,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: DarkThemeColors._error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: DarkThemeColors._error,
            width: 2,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(
          color: DarkThemeColors._textTertiary,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          color: DarkThemeColors._textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: DarkThemeColors._surface,
        selectedItemColor: DarkThemeColors._primaryColor,
        unselectedItemColor: DarkThemeColors._textTertiary,
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
          color: DarkThemeColors._textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: DarkThemeColors._textPrimary,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: DarkThemeColors._textPrimary,
          letterSpacing: -0.5,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: DarkThemeColors._textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: DarkThemeColors._textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: DarkThemeColors._textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: DarkThemeColors._textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: DarkThemeColors._textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: DarkThemeColors._textSecondary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: DarkThemeColors._textPrimary,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: DarkThemeColors._textSecondary,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: DarkThemeColors._textTertiary,
          height: 1.4,
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: DarkThemeColors._divider,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: DarkThemeColors._textSecondary,
        size: 24,
      ),

      // Primary Icon Theme
      primaryIconTheme: const IconThemeData(
        color: DarkThemeColors._primaryColor,
        size: 24,
      ),
    );
  }
}
