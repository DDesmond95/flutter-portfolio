import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_controller.dart';

/// Build both light & dark themes from a single palette selection.
/// Uses Material 3 ColorScheme.fromSeed for tonal harmony.
ThemeBundle buildTheme(AppPalette palette) {
  final seed = _seedFor(palette);

  final light = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.light,
  );
  final dark = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.dark,
  );

  return ThemeBundle(light: _themeFrom(light), dark: _themeFrom(dark));
}

Color _seedFor(AppPalette p) => switch (p) {
  AppPalette.metal => const Color(0xFF556B8E),
  AppPalette.earth => const Color(0xFF996B2F),
  AppPalette.wood => const Color(0xFF2E7D4F),
  AppPalette.fire => const Color(0xFFCF3D2E),
  AppPalette.water => const Color(0xFF1F7A8C),
};

ThemeData _themeFrom(ColorScheme scheme) {
  // Fonts: Noto Sans (Latin/Malay) + Noto Sans SC (Chinese) as fallback.
  final latin = GoogleFonts.notoSans();
  final han = GoogleFonts.notoSansSc();

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: latin.fontFamily,
    fontFamilyFallback: [
      han.fontFamily!,
      'PingFang SC',
      'Hiragino Sans GB',
      'Microsoft YaHei',
      'Source Han Sans SC',
    ],
  );

  final text = _buildTextTheme(base.textTheme);

  return base.copyWith(
    textTheme: text,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      centerTitle: false,
    ),
    // ✅ CardThemeData (not CardTheme)
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant,
      thickness: 1,
      space: 24,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerLowest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.primary, width: 1.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: BorderSide(color: scheme.outlineVariant),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: scheme.inverseSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      // ✅ ColorScheme.onInverseSurface (not inverseOnSurface)
      textStyle: TextStyle(color: scheme.onInverseSurface),
    ),
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  final t = base;

  TextStyle tune(TextStyle? s, {double? size, double? height, FontWeight? w}) {
    s ??= const TextStyle();
    return s.copyWith(
      fontSize: size ?? s.fontSize,
      height: height ?? s.height ?? 1.2,
      fontWeight: w ?? s.fontWeight,
      letterSpacing: 0,
    );
  }

  return t.copyWith(
    displayLarge: tune(t.displayLarge, height: 1.12),
    displayMedium: tune(t.displayMedium, height: 1.14),
    displaySmall: tune(t.displaySmall, height: 1.14),
    headlineLarge: tune(t.headlineLarge, height: 1.16),
    headlineMedium: tune(t.headlineMedium, height: 1.18),
    headlineSmall: tune(t.headlineSmall, height: 1.20),
    titleLarge: tune(t.titleLarge, height: 1.24, w: FontWeight.w600),
    titleMedium: tune(t.titleMedium, height: 1.28, w: FontWeight.w600),
    titleSmall: tune(t.titleSmall, height: 1.30, w: FontWeight.w600),
    bodyLarge: tune(t.bodyLarge, height: 1.50),
    bodyMedium: tune(t.bodyMedium, height: 1.52),
    bodySmall: tune(t.bodySmall, height: 1.48),
    labelLarge: tune(t.labelLarge, height: 1.20, w: FontWeight.w600),
    labelMedium: tune(t.labelMedium, height: 1.20, w: FontWeight.w600),
    labelSmall: tune(t.labelSmall, height: 1.20, w: FontWeight.w600),
  );
}

class ThemeBundle {
  final ThemeData light;
  final ThemeData dark;
  const ThemeBundle({required this.light, required this.dark});
}
