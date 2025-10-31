// lib/theme.dart (replace the previous base/theme code)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'state/app_settings.dart';

final ThemeData lightTheme = _buildTheme(Brightness.light);
final ThemeData darkTheme = _buildTheme(Brightness.dark);

TextTheme _typeScale(TextTheme base) {
  // Start from Inter across the board
  final t = GoogleFonts.interTextTheme(base);

  // Adjust sizes/weights for readability (web)
  return t.copyWith(
    displayLarge: t.displayLarge?.copyWith(
      fontSize: 52,
      fontWeight: FontWeight.w700,
      height: 1.1,
    ),
    displayMedium: t.displayMedium?.copyWith(
      fontSize: 42,
      fontWeight: FontWeight.w700,
      height: 1.15,
    ),
    headlineLarge: t.headlineLarge?.copyWith(
      fontSize: 34,
      fontWeight: FontWeight.w700,
      height: 1.2,
    ),
    headlineMedium: t.headlineMedium?.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.25,
    ),
    titleLarge: t.titleLarge?.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    titleMedium: t.titleMedium?.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.35,
    ),
    bodyLarge: t.bodyLarge?.copyWith(fontSize: 18, height: 1.6),
    bodyMedium: t.bodyMedium?.copyWith(fontSize: 16, height: 1.6),
    bodySmall: t.bodySmall?.copyWith(fontSize: 14, height: 1.5),
    labelLarge: t.labelLarge?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );
}

ThemeData _buildTheme(Brightness b) {
  // Calm palettes inspired by your personality (analytical, steady, trustworthy)
  final seed = (b == Brightness.light)
      ? const Color(0xFF2E7D32)
      : const Color(0xFFA5D6A7);
  final base = ThemeData(
    brightness: b,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: b),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  final text = _typeScale(base.textTheme);

  return base.copyWith(
    textTheme: text,
    // Low-elevation, soft contrast surfaces for a “calm” feel
    cardTheme: CardThemeData(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),

    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      titleTextStyle: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: _MotionAwareTransitions(),
        TargetPlatform.iOS: _MotionAwareTransitions(),
        TargetPlatform.macOS: _MotionAwareTransitions(),
        TargetPlatform.windows: _MotionAwareTransitions(),
        TargetPlatform.linux: _MotionAwareTransitions(),
      },
    ),
  );
}

class _MotionAwareTransitions extends PageTransitionsBuilder {
  const _MotionAwareTransitions();
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> a,
    Animation<double> sa,
    Widget child,
  ) {
    final reduced = context.read<AppSettings?>()?.reducedMotion ?? false;
    if (reduced) return child;
    return FadeTransition(opacity: a, child: child);
  }
}
