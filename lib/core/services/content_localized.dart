import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart' show Locale;
import 'content_service.dart';

extension LocalizedContent on ContentService {
  Future<String> loadBodyLocalized(String path, Locale locale) async {
    // path like: assets/contents/.../foo.md
    final lang = locale.languageCode.toLowerCase();
    if (lang == 'en') {
      return loadBodyByPath(path);
    }
    final dot = path.lastIndexOf('.md');
    if (dot <= 0) return loadBodyByPath(path);

    final localizedPath = '${path.substring(0, dot)}.$lang.md';
    try {
      return await rootBundle.loadString(localizedPath);
    } catch (_) {
      return loadBodyByPath(path);
    }
  }
}
