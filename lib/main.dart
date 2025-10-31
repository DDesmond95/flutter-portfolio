import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'router.dart';
import 'theme.dart';
import 'state/app_settings.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppSettings()..load(),
      child: const PortfolioApp(),
    ),
  );
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    return MaterialApp.router(
      title: 'Desmond Liew | Portfolio',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: settings.themeMode,
      routerConfig: appRouter,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        breakpoints: const [
          Breakpoint(start: 0, end: 450, name: MOBILE),
          Breakpoint(start: 451, end: 900, name: TABLET),
          Breakpoint(start: 901, end: 1200, name: DESKTOP),
          Breakpoint(start: 1201, end: double.infinity, name: '4K'),
        ],
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Gentle downscale on tiny screens to keep line breaks clean
            textScaler: MediaQuery.of(context).size.width < 380
                ? const TextScaler.linear(0.95)
                : const TextScaler.linear(1.0),
          ),
          child: BouncingScrollWrapper.builder(context, child!),
        ),
      ),
    );
  }
}
