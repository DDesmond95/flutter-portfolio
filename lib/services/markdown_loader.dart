// lib/services/markdown_loader.dart
import 'package:flutter/services.dart' show rootBundle;

class MarkdownLoader {
  static final Map<String, Future<String>> _cache = {};

  static Future<String> load(String assetPath) {
    return _cache.putIfAbsent(
      assetPath,
      () => rootBundle.loadString(assetPath),
    );
  }

  /// Naive H1 extractor for title fallback.
  static String? extractH1(String md) {
    for (final line in md.split('\n')) {
      final t = line.trimLeft();
      if (t.startsWith('# ')) return t.replaceFirst('# ', '').trim();
    }
    return null;
  }
}
