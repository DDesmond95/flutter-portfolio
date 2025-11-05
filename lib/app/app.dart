import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'config.dart';
import 'router.dart';
import 'theme.dart';
import 'theme_controller.dart';
import 'lang_controller.dart';

import '../core/services/content_service.dart';
import '../core/services/auth_service.dart';
import '../l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});
  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  bool _ranPostFrameInit = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppConfig>(create: (_) => AppConfig.fromEnv()),
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<ContentService>(create: (_) => ContentService()),
        ChangeNotifierProvider<ThemeController>(
          create: (_) => ThemeController(),
        ),
        ChangeNotifierProvider<LanguageController>(
          create: (_) => LanguageController(),
        ),
        // Stable GoRouter so route doesn't reset on theme/lang changes
        Provider<GoRouter>(
          create: (ctx) => buildRouter(ctx.read<ContentService>()),
        ),
      ],
      child: Builder(
        builder: (context) {
          // first-frame init after providers are mounted
          if (!_ranPostFrameInit) {
            _ranPostFrameInit = true;
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final cfg = context.read<AppConfig>();
              final tc = context.read<ThemeController>();
              final lang = context.read<LanguageController>();
              final auth = context.read<AuthService>();

              await Future.wait([tc.load(), lang.load(), auth.load()]);

              final prefs = await SharedPreferences.getInstance();
              final hasPalette = prefs.containsKey('theme.palette');
              final hasMode = prefs.containsKey('theme.mode');

              if (!hasPalette) {
                await tc.setPalette(_parsePalette(cfg.initialPaletteName));
              }
              if (!hasMode) {
                await tc.setMode(_parseMode(cfg.initialModeName));
              }
            });
          }

          final cfg = context.watch<AppConfig>();
          final themeCtrl = context.watch<ThemeController>();
          final langCtrl = context.watch<LanguageController>();
          final themes = buildTheme(themeCtrl.palette);
          final router = context.read<GoRouter>();

          return MaterialApp.router(
            title: cfg.siteName,
            debugShowCheckedModeBanner: false,
            theme: themes.light,
            darkTheme: themes.dark,
            themeMode: themeCtrl.mode,
            routerConfig: router,

            // ✅ i18n
            locale: langCtrl.locale, // null → follow system
            supportedLocales: const [Locale('en'), Locale('zh'), Locale('ms')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],

            // ✅ responsive wrapper
            builder: (context, child) => ResponsiveBreakpoints.builder(
              child: MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child!,
              ),
              breakpoints: const [
                Breakpoint(start: 0, end: 480, name: MOBILE),
                Breakpoint(start: 481, end: 768, name: TABLET),
                Breakpoint(start: 769, end: 1024, name: TABLET),
                Breakpoint(start: 1025, end: 1440, name: DESKTOP),
                Breakpoint(start: 1441, end: double.infinity, name: '4K'),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Helpers to parse .env strings → ThemeController enums/modes
AppPalette _parsePalette(String name) {
  switch (name.toLowerCase()) {
    case 'earth':
      return AppPalette.earth;
    case 'wood':
      return AppPalette.wood;
    case 'fire':
      return AppPalette.fire;
    case 'water':
      return AppPalette.water;
    case 'metal':
    default:
      return AppPalette.metal;
  }
}

ThemeMode _parseMode(String name) {
  switch (name.toLowerCase()) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    case 'system':
    default:
      return ThemeMode.system;
  }
}
