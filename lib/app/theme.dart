import 'package:flutter/material.dart';
import 'theme_controller.dart';

ThemeBundle buildTheme(AppPalette palette) {
  final seed = _seedFor(palette);

  return ThemeBundle(
    light: _themeFrom(
      ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
    ),
    dark: _themeFrom(
      ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
    ),
  );
}

Color _seedFor(AppPalette p) => switch (p) {
  AppPalette.metal => const Color(0xFF556B8E),
  AppPalette.earth => const Color(0xFF996B2F),
  AppPalette.wood => const Color(0xFF2E7D4F),
  AppPalette.fire => const Color(0xFFCF3D2E),
  AppPalette.water => const Color(0xFF1F7A8C),
};

ThemeData _themeFrom(ColorScheme scheme) {
  // Font families
  const primary = 'NotoSans';
  const serifCjk = 'NotoSerifSC';
  const hanSans = 'NotoSansSC';
  const symbols2 = 'NotoSansSymbols2';
  const emoji = 'NotoColorEmoji';
  const mono = 'JetBrainsMono';

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: primary,
    fontFamilyFallback: const [hanSans, serifCjk, symbols2, emoji],
    visualDensity: VisualDensity.standard,
    splashFactory: NoSplash.splashFactory,
  );

  final text = _textTheme(base.textTheme, serifCjk, mono);

  return base.copyWith(
    textTheme: text,

    // ---------------------------
    // AppBar
    // ---------------------------
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      centerTitle: false,
      elevation: 0,
      toolbarHeight: 64,
      titleTextStyle: text.titleLarge?.copyWith(
        fontSize: (text.titleLarge?.fontSize ?? 20) + 2,
        fontWeight: FontWeight.w700,
      ),
    ),

    // ---------------------------
    // Navigation Buttons
    // ---------------------------
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
          text.titleMedium?.copyWith(fontWeight: FontWeight.w600, height: 1.25),
        ),
        foregroundColor: WidgetStateProperty.all(scheme.onSurface),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    ),

    // ---------------------------
    // Popup Menus
    // ---------------------------
    popupMenuTheme: PopupMenuThemeData(
      textStyle: text.bodyMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 6,
    ),

    // ---------------------------
    // Drawer
    // ---------------------------
    listTileTheme: ListTileThemeData(
      titleTextStyle: text.titleMedium,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // ---------------------------
    // Cards
    // ---------------------------
    cardTheme: CardTheme(
      elevation: 0,
      color: scheme.surfaceContainerLowest,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ).data,

    // ---------------------------
    // Dividers
    // ---------------------------
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant,
      thickness: 1,
      space: 24,
    ),

    // ---------------------------
    // Inputs
    // ---------------------------
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerLowest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.primary, width: 1.6),
      ),
    ),

    // ---------------------------
    // Chips
    // ---------------------------
    chipTheme: ChipThemeData(
      labelStyle: text.bodyMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: BorderSide(color: scheme.outlineVariant),
      selectedColor: scheme.primary.withValues(alpha: 0.14),
    ),

    // ---------------------------
    // Tooltip
    // ---------------------------
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: scheme.inverseSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: TextStyle(color: scheme.onInverseSurface),
    ),
  );
}

//
// ---------------------------
//  TEXT SYSTEM 2.0 (Replaces Flutter Defaults)
// ---------------------------
//
TextTheme _textTheme(TextTheme base, String serif, String mono) {
  TextStyle tune(
    TextStyle? s, {
    double? size,
    double? height,
    FontWeight? weight,
    String? family,
  }) {
    s ??= const TextStyle();
    return s.copyWith(
      fontFamily: family ?? s.fontFamily,
      fontSize: size ?? s.fontSize,
      height: height ?? s.height ?? 1.2,
      fontWeight: weight ?? s.fontWeight,
      letterSpacing: 0,
    );
  }

  final t = base;

  return t
      .copyWith(
        // High-level display
        displayLarge: tune(
          t.displayLarge,
          family: serif,
          height: 1.10,
          weight: FontWeight.w600,
        ),
        displayMedium: tune(
          t.displayMedium,
          family: serif,
          height: 1.12,
          weight: FontWeight.w600,
        ),
        displaySmall: tune(
          t.displaySmall,
          family: serif,
          height: 1.12,
          weight: FontWeight.w600,
        ),

        // Page section headings
        headlineLarge: tune(
          t.headlineLarge,
          family: serif,
          height: 1.15,
          weight: FontWeight.w600,
        ),
        headlineMedium: tune(
          t.headlineMedium,
          family: serif,
          height: 1.18,
          weight: FontWeight.w600,
        ),
        headlineSmall: tune(
          t.headlineSmall,
          family: serif,
          height: 1.20,
          weight: FontWeight.w600,
        ),

        // Titles (navigation + cards)
        titleLarge: tune(t.titleLarge, weight: FontWeight.w700, height: 1.24),
        titleMedium: tune(t.titleMedium, weight: FontWeight.w600, height: 1.28),
        titleSmall: tune(t.titleSmall, weight: FontWeight.w600, height: 1.30),

        // Body text
        bodyLarge: tune(t.bodyLarge, height: 1.50),
        bodyMedium: tune(t.bodyMedium, height: 1.52),
        bodySmall: tune(t.bodySmall, height: 1.48),

        // Labels (buttons, chips)
        labelLarge: tune(t.labelLarge, weight: FontWeight.w600, height: 1.20),
        labelMedium: tune(t.labelMedium, weight: FontWeight.w600, height: 1.20),
        labelSmall: tune(t.labelSmall, weight: FontWeight.w600, height: 1.20),
      )
      .apply(fontFamilyFallback: [mono]);
}

class ThemeBundle {
  final ThemeData light;
  final ThemeData dark;
  const ThemeBundle({required this.light, required this.dark});
}
