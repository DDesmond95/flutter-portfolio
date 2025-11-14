import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart' show Locale;

import '../markdown/front_matter.dart';
import 'content_service.dart';

extension LocalizedContent on ContentService {
  Future<String> loadBodyLocalized(String canonicalPath, Locale locale) async {
    final lang = locale.languageCode.toLowerCase();

    // Canonical language → use normal loader (already strips front matter)
    if (lang == 'en') {
      return loadBodyByPath(canonicalPath);
    }

    final localizedPath = _swapLangSegment(canonicalPath, lang);

    try {
      final raw = await rootBundle.loadString(localizedPath);
      // Strip front matter if present; body is what we want to render
      return parseFrontMatter(raw).body;
    } catch (_) {
      // Fallback to canonical English content
      return loadBodyByPath(canonicalPath);
    }
  }

  /// "assets/contents/en/pages/about.md"
  ///   → "assets/contents/ms/pages/about.md" (lang = "ms")
  String _swapLangSegment(String path, String lang) {
    const prefix = 'assets/contents/';
    if (!path.startsWith(prefix)) return path;

    final rest = path.substring(prefix.length); // "en/pages/about.md"
    final parts = rest.split('/'); // ["en","pages","about.md"]
    if (parts.isEmpty) return path;

    parts[0] = lang;
    return '$prefix${parts.join('/')}';
  }
}
