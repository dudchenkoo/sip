import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// MMDSmart Call Center Connect Theme
/// Professional, data-heavy, compact design language
/// Supports Light and Dark modes
class AppTheme {
  AppTheme._();

  // ============================================
  // LIGHT THEME
  // ============================================
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: _lightColorScheme,
        scaffoldBackgroundColor: AppColors.background,
        visualDensity: VisualDensity.compact,

        // AppBar Theme - Compact
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 1,
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.textPrimary,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          toolbarHeight: 52,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimary, size: 22),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        ),

        // Bottom Navigation - Compact
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.gray500,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),

        // Card Theme - Compact
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            side: const BorderSide(color: AppColors.border, width: 1),
          ),
          margin: EdgeInsets.zero,
        ),

        // Elevated Button - Compact
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            minimumSize: const Size(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),

        // Outlined Button - Compact
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            minimumSize: const Size(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),

        // Text Button - Compact
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: const Size(0, 36),
            textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),

        // Input Decoration - Compact
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceVariant,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          hintStyle: const TextStyle(fontSize: 14, color: AppColors.gray400),
          labelStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),

        // Chip Theme - Compact
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceVariant,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
        ),

        // Divider
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 1,
        ),

        // List Tile - Compact
        listTileTheme: const ListTileThemeData(
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          minVerticalPadding: 8,
          titleTextStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          subtitleTextStyle: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),

        // Snackbar
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.darkGray,
          contentTextStyle: const TextStyle(fontSize: 13, color: AppColors.white),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),

        // Dialog
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        // Bottom Sheet
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusMd)),
          ),
        ),

        // Text Theme - Compact
        textTheme: _lightTextTheme,
      );

  // ============================================
  // DARK THEME
  // ============================================
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: _darkColorScheme,
        scaffoldBackgroundColor: AppColorsDark.background,
        visualDensity: VisualDensity.compact,

        // AppBar Theme - Compact Dark
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 1,
          backgroundColor: AppColorsDark.surface,
          foregroundColor: AppColorsDark.textPrimary,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          toolbarHeight: 52,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColorsDark.textPrimary,
          ),
          iconTheme: IconThemeData(color: AppColorsDark.textPrimary, size: 22),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),

        // Bottom Navigation - Compact Dark
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColorsDark.surface,
          selectedItemColor: AppColorsDark.primary,
          unselectedItemColor: AppColorsDark.gray500,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),

        // Card Theme - Compact Dark
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColorsDark.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            side: const BorderSide(color: AppColorsDark.border, width: 1),
          ),
          margin: EdgeInsets.zero,
        ),

        // Elevated Button - Compact Dark
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColorsDark.primary,
            foregroundColor: AppColors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            minimumSize: const Size(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),

        // Outlined Button - Compact Dark
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColorsDark.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            minimumSize: const Size(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            side: const BorderSide(color: AppColorsDark.primary, width: 1.5),
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),

        // Input Decoration - Compact Dark
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColorsDark.surfaceVariant,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            borderSide: const BorderSide(color: AppColorsDark.primary, width: 2),
          ),
          hintStyle: const TextStyle(fontSize: 14, color: AppColorsDark.gray500),
          labelStyle: const TextStyle(fontSize: 13, color: AppColorsDark.textSecondary),
        ),

        // Chip Theme - Compact Dark
        chipTheme: ChipThemeData(
          backgroundColor: AppColorsDark.surfaceVariant,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColorsDark.textPrimary,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
        ),

        // Divider Dark
        dividerTheme: const DividerThemeData(
          color: AppColorsDark.divider,
          thickness: 1,
          space: 1,
        ),

        // List Tile - Compact Dark
        listTileTheme: const ListTileThemeData(
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          minVerticalPadding: 8,
          titleTextStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColorsDark.textPrimary,
          ),
          subtitleTextStyle: TextStyle(fontSize: 12, color: AppColorsDark.textSecondary),
        ),

        // Snackbar Dark
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColorsDark.surfaceVariant,
          contentTextStyle: const TextStyle(fontSize: 13, color: AppColorsDark.textPrimary),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),

        // Dialog Dark
        dialogTheme: DialogThemeData(
          backgroundColor: AppColorsDark.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColorsDark.textPrimary,
          ),
        ),

        // Bottom Sheet Dark
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColorsDark.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusMd)),
          ),
        ),

        // Text Theme - Compact Dark
        textTheme: _darkTextTheme,
      );

  // ============================================
  // COLOR SCHEMES
  // ============================================
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.gray600,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.gray100,
    onSecondaryContainer: AppColors.gray700,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.textSecondary,
    error: AppColors.error,
    onError: AppColors.white,
    outline: AppColors.border,
    outlineVariant: AppColors.gray200,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColorsDark.primary,
    onPrimary: AppColors.white,
    primaryContainer: AppColorsDark.primaryContainer,
    onPrimaryContainer: AppColorsDark.primaryLight,
    secondary: AppColorsDark.gray400,
    onSecondary: AppColorsDark.background,
    secondaryContainer: AppColorsDark.gray700,
    onSecondaryContainer: AppColorsDark.gray300,
    surface: AppColorsDark.surface,
    onSurface: AppColorsDark.textPrimary,
    surfaceContainerHighest: AppColorsDark.surfaceVariant,
    onSurfaceVariant: AppColorsDark.textSecondary,
    error: AppColors.error,
    onError: AppColors.white,
    outline: AppColorsDark.border,
    outlineVariant: AppColorsDark.gray700,
  );

  // ============================================
  // TEXT THEMES - Compact
  // ============================================
  static const TextTheme _lightTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
    displayMedium: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
    displaySmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
    bodyMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
    bodySmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
    labelLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    labelMedium: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
  );

  static const TextTheme _darkTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: AppColorsDark.textPrimary),
    displayMedium: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: AppColorsDark.textPrimary),
    displaySmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: AppColorsDark.textPrimary),
    headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColorsDark.textPrimary),
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColorsDark.textPrimary),
    headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColorsDark.textPrimary),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColorsDark.textPrimary),
    titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColorsDark.textPrimary),
    titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColorsDark.textPrimary),
    bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColorsDark.textPrimary),
    bodyMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColorsDark.textPrimary),
    bodySmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: AppColorsDark.textSecondary),
    labelLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColorsDark.textPrimary),
    labelMedium: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColorsDark.textPrimary),
    labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColorsDark.textSecondary),
  );
}

/// Dark Mode Color Palette
abstract class AppColorsDark {
  // Primary Brand Colors (brighter for dark mode)
  static const Color primary = Color(0xFFFF8F5C);
  static const Color primaryLight = Color(0xFFFFB088);
  static const Color primaryDark = Color(0xFFFF6B35);
  static const Color primaryContainer = Color(0xFF3D2820);

  // Background & Surface
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceVariant = Color(0xFF2A2A2A);

  // Gray Scale
  static const Color gray700 = Color(0xFF3A3A3A);
  static const Color gray600 = Color(0xFF4A4A4A);
  static const Color gray500 = Color(0xFF6B6B6B);
  static const Color gray400 = Color(0xFF8B8B8B);
  static const Color gray300 = Color(0xFFABABAB);
  static const Color gray200 = Color(0xFFCBCBCB);

  // Text Colors
  static const Color textPrimary = Color(0xFFE8E8E8);
  static const Color textSecondary = Color(0xFFABABAB);
  static const Color textTertiary = Color(0xFF6B6B6B);

  // Border & Divider
  static const Color border = Color(0xFF3A3A3A);
  static const Color divider = Color(0xFF2A2A2A);
}
