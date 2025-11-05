import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  final String siteName;
  final String tagline;
  final String timezone;
  final bool enableSearch;
  final bool enableNewsletter;
  final bool showMeta;
  final bool showCreative;
  final bool useHashRouter;
  final String basePath;

  final String initialPaletteName; // metal|earth|wood|fire|water
  final String initialModeName; // system|light|dark

  const AppConfig({
    required this.siteName,
    required this.tagline,
    required this.timezone,
    required this.enableSearch,
    required this.enableNewsletter,
    required this.showMeta,
    required this.showCreative,
    required this.useHashRouter,
    required this.basePath,
    required this.initialPaletteName,
    required this.initialModeName,
  });

  factory AppConfig.fromEnv() {
    String s(String key, String def) => (dotenv.maybeGet(key) ?? def).trim();

    bool b(String key, bool def) {
      final v = s(key, def ? 'true' : 'false').toLowerCase();
      return v == 'true' || v == '1' || v == 'yes';
    }

    return AppConfig(
      siteName: s('SITE_NAME', 'Desmond Liew — Portfolio'),
      tagline: s('SITE_TAGLINE', 'Calm, privacy-first AI systems.'),
      timezone: s('TIMEZONE', 'Asia/Kuching'),
      enableSearch: b('ENABLE_SEARCH', true),
      enableNewsletter: b('ENABLE_NEWSLETTER', false),
      showMeta: b('SHOW_META_REALM', true),
      showCreative: b('SHOW_CREATIVE_REALM', true),
      useHashRouter: b('USE_HASH_ROUTER', true),
      basePath: s('BASE_PATH', ''),
      initialPaletteName: s('THEME_PALETTE', 'metal').toLowerCase(),
      initialModeName: s('THEME_MODE', 'system').toLowerCase(),
    );
  }
}
