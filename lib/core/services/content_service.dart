import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../markdown/front_matter.dart';
import '../models/content_meta.dart';
import 'asset_index.dart';
import 'crypto_service.dart';

class ContentService extends ChangeNotifier {
  bool _loaded = false;
  final List<ContentMeta> _all = [];
  List<ContentMeta> get all => List.unmodifiable(_all);

  Future<void> ensureLoaded() async {
    if (_loaded) return;

    // 🔁 NEW: load prebuilt JSON index instead of scanning & parsing all .md
    final metas = await loadContentIndex();
    if (kDebugMode) {
      print('[ContentService] loaded ${metas.length} content index entries');
      for (final m in metas) {
        print(
          '[ContentService] meta: type=${m.type} slug=${m.slug} visibility=${m.visibility} path=${m.path}',
        );
      }
    }

    _all
      ..clear()
      ..addAll(metas);

    _loaded = true;
    notifyListeners();
  }

  // ❌ _toMeta() is no longer needed and can be removed.

  Future<String> loadBodyByPath(String path) async {
    // 🔐 NEW: load encrypted bytes, decrypt, then strip front-matter
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();
    final markdown = await CryptoService.decryptBytesToMarkdown(bytes);
    return parseFrontMatter(markdown).body;
  }

  ContentMeta? findByTypeAndSlug(String type, String slug) {
    try {
      return _all.firstWhere((e) => e.type == type && e.slug == slug);
    } catch (_) {
      return null;
    }
  }

  List<ContentMeta> listByType(String type, {bool publicOnly = true}) {
    final xs = _all.where((e) => e.type == type);
    final f = publicOnly ? xs.where((e) => e.isPublic) : xs;
    final list = f.toList();
    list.sort(
      (a, b) => (b.date ?? DateTime(1970)).compareTo(a.date ?? DateTime(1970)),
    );
    return list;
  }

  // ----------------------------------------------------------------------
  // 🔒 PRIVATE CONTENT DETECTION FOR ROUTER REDIRECT (unchanged)
  // ----------------------------------------------------------------------

  /// Find ContentMeta by matching slug from a route path
  ContentMeta? findMetaByPath(String path) {
    // Extract last path section as slug
    // e.g. /foundation/foundation-credits → slug: foundation-credits
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
