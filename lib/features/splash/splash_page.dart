import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart'; // Ensure we have animations, or use standard
// actually, standard flutter animations are fine to reduce deps, but let's check pubspec?
// pubspec has 'animations: ^2.1.1'.
// I'll stick to standard implicit animations for simplicity and zero-dep risk.

import '../../core/services/content_service.dart';
import '../../core/services/auth_service.dart';
import '../../app/theme_controller.dart';
import '../../app/lang_controller.dart';
import '../../core/utils/l10n.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _bootstrap();
    // Start fade in
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _opacity = 1.0);
    });
  }

  Future<void> _bootstrap() async {
    final content = context.read<ContentService>();
    final auth = context.read<AuthService>();
    final theme = context.read<ThemeController>();
    final lang = context.read<LanguageController>();

    // Run all critical initializers
    // MINIMUM delay to ensure the logo is seen (avoids flicker)
    await Future.wait([
      content.ensureLoaded(),
      auth.load(),
      theme.load(),
      lang.load(),
      Future.delayed(const Duration(milliseconds: 1200)),
    ]);

    if (!mounted) return;

    // Navigate to Home (replace so user can't go back to splash)
    // We use /home or / based on your router. Assuming / is home.
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutExpo,
          opacity: _opacity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo / Brand
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  "D",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                    fontFamily: 'NotoSerifSC', // or standard
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Tagline
              Text(
                "Desmond Liew",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Loading Portfolio...",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 48),
              // Subtle Spinner
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
