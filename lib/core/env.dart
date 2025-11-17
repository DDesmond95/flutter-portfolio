import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Env helper that prefers `.env` (local dev),
/// and falls back to `--dart-define` values (GitHub Secrets / CI).
class Env {
  // ───────────────────────────────────────────────────────────────
  // Internal helpers
  // ───────────────────────────────────────────────────────────────

  static String _string(
    String key, {
    required String dartDefineDefault,
    String? fallback,
  }) {
    // 1) Prefer .env (local dev)
    final fromDotEnv = dotenv.env[key];
    if (fromDotEnv != null && fromDotEnv.isNotEmpty) {
      return fromDotEnv;
    }

    // 2) Fall back to dart-define (compile-time constant)
    if (dartDefineDefault.isNotEmpty) {
      return dartDefineDefault;
    }

    // 3) Optional final fallback
    return fallback ?? '';
  }

  static bool _bool(
    String key, {
    required bool fallback,
    String dartDefineDefault = '',
  }) {
    // .env overrides, otherwise dart-define
    final fromDotEnv = dotenv.env[key];
    final raw = (fromDotEnv != null && fromDotEnv.isNotEmpty)
        ? fromDotEnv
        : dartDefineDefault;

    final v = raw.toLowerCase();
    if (v == 'true') return true;
    if (v == 'false') return false;
    return fallback;
  }

  // ───────────────────────────────────────────────────────────────
  // dart-define defaults (compile-time)
  // ───────────────────────────────────────────────────────────────

  // Core identity
  static const _siteNameD = String.fromEnvironment(
    'SITE_NAME',
    defaultValue: 'Portfolio',
  );

  static const _siteTaglineD = String.fromEnvironment(
    'SITE_TAGLINE',
    defaultValue: '',
  );

  static const _contactEmailD = String.fromEnvironment(
    'CONTACT_EMAIL',
    defaultValue: '',
  );

  static const _timezoneD = String.fromEnvironment(
    'TIMEZONE',
    defaultValue: 'Asia/Kuching',
  );

  // Feature flags (string forms for bool helper)
  static const _enableSearchD = String.fromEnvironment(
    'ENABLE_SEARCH',
    defaultValue: '',
  );

  static const _showMetaRealmD = String.fromEnvironment(
    'SHOW_META_REALM',
    defaultValue: '',
  );

  static const _showCreativeRealmD = String.fromEnvironment(
    'SHOW_CREATIVE_REALM',
    defaultValue: '',
  );

  static const _enableNewsletterD = String.fromEnvironment(
    'ENABLE_NEWSLETTER',
    defaultValue: '',
  );

  static const _useHashRouterD = String.fromEnvironment(
    'USE_HASH_ROUTER',
    defaultValue: '',
  );

  // Theming
  static const _defaultThemeD = String.fromEnvironment(
    'DEFAULT_THEME',
    defaultValue: 'system',
  );

  static const _themePaletteD = String.fromEnvironment(
    'THEME_PALETTE',
    defaultValue: 'wood',
  );

  static const _themeModeD = String.fromEnvironment(
    'THEME_MODE',
    defaultValue: 'system',
  );

  // Auth canary (for passphrase verification)
  static const _authCanarySaltD = String.fromEnvironment(
    'AUTH_CANARY_SALT',
    defaultValue: '',
  );

  static const _authCanaryNonceD = String.fromEnvironment(
    'AUTH_CANARY_NONCE',
    defaultValue: '',
  );

  static const _authCanaryDataD = String.fromEnvironment(
    'AUTH_CANARY_DATA',
    defaultValue: '',
  );

  static const _authCanaryMacD = String.fromEnvironment(
    'AUTH_CANARY_MAC',
    defaultValue: '',
  );

  // ───────────────────────────────────────────────────────────────
  // Public getters (existing + new)
  // ───────────────────────────────────────────────────────────────

  /// SITE_NAME
  static String get siteName =>
      _string('SITE_NAME', dartDefineDefault: _siteNameD);

  /// SITE_TAGLINE
  static String get tagline =>
      _string('SITE_TAGLINE', dartDefineDefault: _siteTaglineD);

  /// CONTACT_EMAIL
  static String get contactEmail =>
      _string('CONTACT_EMAIL', dartDefineDefault: _contactEmailD);

  /// TIMEZONE
  static String get timezone =>
      _string('TIMEZONE', dartDefineDefault: _timezoneD);

  /// ENABLE_SEARCH (default: true)
  static bool get enableSearch =>
      _bool('ENABLE_SEARCH', fallback: true, dartDefineDefault: _enableSearchD);

  /// SHOW_META_REALM (default: true)
  static bool get showMetaRealm => _bool(
    'SHOW_META_REALM',
    fallback: true,
    dartDefineDefault: _showMetaRealmD,
  );

  /// SHOW_CREATIVE_REALM (default: true)
  static bool get showCreative => _bool(
    'SHOW_CREATIVE_REALM',
    fallback: true,
    dartDefineDefault: _showCreativeRealmD,
  );

  /// ENABLE_NEWSLETTER (default: false)
  static bool get enableNewsletter => _bool(
    'ENABLE_NEWSLETTER',
    fallback: false,
    dartDefineDefault: _enableNewsletterD,
  );

  /// USE_HASH_ROUTER (default: true)
  static bool get useHashRouter => _bool(
    'USE_HASH_ROUTER',
    fallback: true,
    dartDefineDefault: _useHashRouterD,
  );

  /// Legacy: DEFAULT_THEME (mode / overall default, e.g. "system" / "light" / "dark")
  static String get defaultTheme => _string(
    'DEFAULT_THEME',
    dartDefineDefault: _defaultThemeD,
    fallback: 'system',
  );

  /// THEME_PALETTE (e.g. "wood", "metal", "earth")
  static String get themePalette => _string(
    'THEME_PALETTE',
    dartDefineDefault: _themePaletteD,
    fallback: 'wood',
  );

  /// THEME_MODE (e.g. "system", "light", "dark")
  static String get themeMode =>
      _string('THEME_MODE', dartDefineDefault: _themeModeD, fallback: 'system');

  // ───────────────────────────────────────────────────────────────
  // Auth canary values (for passphrase verification)
  // ───────────────────────────────────────────────────────────────

  static String get authCanarySalt =>
      _string('AUTH_CANARY_SALT', dartDefineDefault: _authCanarySaltD);

  static String get authCanaryNonce =>
      _string('AUTH_CANARY_NONCE', dartDefineDefault: _authCanaryNonceD);

  static String get authCanaryData =>
      _string('AUTH_CANARY_DATA', dartDefineDefault: _authCanaryDataD);

  static String get authCanaryMac =>
      _string('AUTH_CANARY_MAC', dartDefineDefault: _authCanaryMacD);
}
