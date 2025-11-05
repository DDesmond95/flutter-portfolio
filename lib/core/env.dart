import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get siteName => dotenv.env['SITE_NAME'] ?? 'Portfolio';
  static String get tagline => dotenv.env['SITE_TAGLINE'] ?? '';
  static String get contactEmail => dotenv.env['CONTACT_EMAIL'] ?? '';
  static String get timezone => dotenv.env['TIMEZONE'] ?? 'Asia/Kuching';

  static bool get enableSearch => _bool('ENABLE_SEARCH', true);
  static bool get showMetaRealm => _bool('SHOW_META_REALM', true);
  static bool get showCreative => _bool('SHOW_CREATIVE_REALM', true);
  static String get defaultTheme => dotenv.env['DEFAULT_THEME'] ?? 'system';

  static bool _bool(String k, bool def) {
    final v = dotenv.env[k]?.toLowerCase();
    if (v == 'true') return true;
    if (v == 'false') return false;
    return def;
  }
}
