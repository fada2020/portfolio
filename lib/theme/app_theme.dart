import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static const Color _primary = Color(0xFF5C6BF2);
  static const Color _onPrimary = Colors.white;
  static const Color _secondary = Color(0xFFFF6B6B);
  static const Color _tertiary = Color(0xFF4CD4B0);
  static const Color _backgroundLight = Color(0xFFF6F7FB);
  static const Color _surfaceLight = Colors.white;
  static const Color _surfaceVariantLight = Color(0xFFE2E5F2);
  static const Color _outlineLight = Color(0xFFD0D4E6);
  static const Color _textPrimaryLight = Color(0xFF161A2B);
  static const Color _textMutedLight = Color(0xFF60658C);

  static const Color _backgroundDark = Color(0xFF0F1120);
  static const Color _surfaceDark = Color(0xFF1C2033);
  static const Color _surfaceVariantDark = Color(0xFF2A2F45);
  static const Color _outlineDark = Color(0xFF3A3F58);
  static const Color _textPrimaryDark = Color(0xFFE7EAF9);
  static const Color _textMutedDark = Color(0xFF9AA0C8);

  static ThemeData get light => _buildTheme(_lightColorScheme, Brightness.light);
  static ThemeData get dark => _buildTheme(_darkColorScheme, Brightness.dark);

  static ThemeData _buildTheme(ColorScheme scheme, Brightness brightness) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: brightness,
    );

    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );

    return base.copyWith(
      scaffoldBackgroundColor: scheme.background,
      textTheme: textTheme,
      cardTheme: CardTheme(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outline.withOpacity(0.4)),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.background,
        elevation: 0,
        foregroundColor: scheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          side: MaterialStateProperty.resolveWith(
            (states) => BorderSide(color: scheme.outline.withOpacity(states.contains(MaterialState.hovered) ? 0.8 : 0.5)),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        labelStyle: textTheme.labelMedium,
        backgroundColor: scheme.surfaceVariant,
        selectedColor: scheme.primary.withOpacity(0.12),
        side: BorderSide(color: scheme.outline.withOpacity(0.3)),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outline.withOpacity(0.3),
        space: 32,
        thickness: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primary.withOpacity(0.12),
        labelTextStyle: MaterialStateProperty.all(textTheme.labelSmall),
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: textTheme.titleMedium,
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        iconColor: scheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: _primary,
    onPrimary: _onPrimary,
    primaryContainer: Color(0xFFE0E4FF),
    onPrimaryContainer: _textPrimaryLight,
    secondary: _secondary,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFFFE0DE),
    onSecondaryContainer: Color(0xFF5A1E1E),
    tertiary: _tertiary,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFCBF4E7),
    onTertiaryContainer: Color(0xFF104234),
    error: Color(0xFFD54C4C),
    onError: Colors.white,
    errorContainer: Color(0xFFFFE0E0),
    onErrorContainer: Color(0xFF410E0B),
    background: _backgroundLight,
    onBackground: _textPrimaryLight,
    surface: _surfaceLight,
    onSurface: _textPrimaryLight,
    surfaceVariant: _surfaceVariantLight,
    onSurfaceVariant: _textMutedLight,
    outline: _outlineLight,
    outlineVariant: Color(0xFFC6CADE),
    shadow: Colors.black26,
    scrim: Colors.black87,
    inverseSurface: Color(0xFF1F2236),
    onInverseSurface: Colors.white,
    inversePrimary: Color(0xFFCED3FF),
    surfaceTint: _primary,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: _primary,
    onPrimary: _onPrimary,
    primaryContainer: Color(0xFF3A47A8),
    onPrimaryContainer: Colors.white,
    secondary: _secondary,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFF7A2C2C),
    onSecondaryContainer: Color(0xFFFFEBE9),
    tertiary: _tertiary,
    onTertiary: Colors.black,
    tertiaryContainer: Color(0xFF155D48),
    onTertiaryContainer: Color(0xFFE2FFF6),
    error: Color(0xFFFF8A80),
    onError: Colors.black,
    errorContainer: Color(0xFF8A1F1F),
    onErrorContainer: Color(0xFFFFE3E0),
    background: _backgroundDark,
    onBackground: _textPrimaryDark,
    surface: _surfaceDark,
    onSurface: _textPrimaryDark,
    surfaceVariant: _surfaceVariantDark,
    onSurfaceVariant: _textMutedDark,
    outline: _outlineDark,
    outlineVariant: Color(0xFF4A4F68),
    shadow: Colors.black54,
    scrim: Colors.black87,
    inverseSurface: Color(0xFFE6E9F9),
    onInverseSurface: Color(0xFF15182A),
    inversePrimary: Color(0xFFB2B9FF),
    surfaceTint: _primary,
  );
}
