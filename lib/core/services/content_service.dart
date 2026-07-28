import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../markdown/front_matter.dart';
import '../models/content_meta.dart';
import 'asset_index.dart';
import 'crypto_service.dart';

class ContentService extends ChangeNotifier {
  bool _loaded = false;
  bool get isLoaded => _loaded;
  final List<ContentMeta> _all = [];
  List<ContentMeta> get all => List.unmodifiable(_all);

  String? _loadError;
  String? get loadError => _loadError;

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    if (_loadError != null) return; // Don't retry failed loads

    try {
      final metas = await loadContentIndex();
      _all
        ..clear()
        ..addAll(metas);
      _loaded = true;
      notifyListeners();
    } catch (e) {
      _loadError = e.toString();
      debugPrint('[ContentService] Load error: $_loadError');
    }
  }



  // Simple in-memory cache for decrypted content
  final Map<String, String> _bodyCache = {};

  Future<String> loadBodyByPath(String path) async {
    // 1. Check cache
    if (_bodyCache.containsKey(path)) {
      return _bodyCache[path]!;
    }

    try {
      // 2. Load bytes
      final data = await rootBundle.load(path);
      final bytes = data.buffer.asUint8List();

      // 3. Decrypt or Decode
      String markdown;
      if (path.endsWith('.enc')) {
        markdown = await CryptoService.decryptBytesToMarkdown(bytes);
      } else {
        // Fallback for plain .md (mostly for debug/local testing)
        markdown = utf8.decode(bytes);
      }

      // 4. Parse front-matter
      final body = parseFrontMatter(markdown).body;

      // 5. Store in cache
      _bodyCache[path] = body;

      return body;
    } catch (e) {
      debugPrint('[ContentService] Error loading body for $path: $e');
      return '';
    }
  }

  ContentMeta? findByTypeAndSlug(String type, String slug, {String? lang}) {
    final matches = _all.where((e) => e.type == type && e.slug == slug).toList();
    if (matches.isEmpty) return null;

    final target = lang ?? 'en';
    return matches.firstWhere(
      (e) => e.lang == target,
      orElse: () => matches.firstWhere(
        (e) => e.lang == 'en',
        orElse: () => matches.first,
      ),
    );
  }

  List<ContentMeta> listByType(String type, {bool publicOnly = true, String? lang}) {
    var xs = _all.where((e) => e.type == type);
    if (publicOnly) {
      xs = xs.where((e) => e.isPublic);
    }

    // Dedup / Localize logic
    // If multiple items have same slug, pick best match for 'lang' (or 'en')
    final grouped = <String, List<ContentMeta>>{};
    for (final x in xs) {
      grouped.putIfAbsent(x.slug, () => []).add(x);
    }

    final result = <ContentMeta>[];
    for (final list in grouped.values) {
       if (list.isEmpty) continue;
       if (list.length == 1) {
         result.add(list.first);
         continue;
       }

       // We have duplicates/variants. Determine best match.
       final targetLang = lang ?? 'en';

       // 1. Exact lang match
       final exact = list.firstWhere((e) => e.lang == targetLang, orElse: () => list.firstWhere((e) => e.lang == 'en', orElse: () => list.first));
       result.add(exact);
    }

    result.sort(
      (a, b) => (b.date ?? DateTime(1970)).compareTo(a.date ?? DateTime(1970)),
    );
    return result;
  }

  // ----------------------------------------------------------------------
  // 🔒 PRIVATE CONTENT DETECTION FOR ROUTER REDIRECT (unchanged)
  // ----------------------------------------------------------------------

  /// Find ContentMeta by matching slug from a route path
  ContentMeta? findMetaByPath(String path) {
    // Extract last path section as slug
    // e.g. /foundation/credits → slug: credits
    final slug = path.split('/').last.trim();
    if (slug.isEmpty) return null;

    try {
      return _all.firstWhere((m) => m.slug == slug);
    } catch (_) {
      return null;
    }
  }

  /// Check if a route points to a private content item
  bool isPrivatePath(String path) {
    final meta = findMetaByPath(path);
    if (meta == null) return false;
    return meta.isPrivate;
  }
}
