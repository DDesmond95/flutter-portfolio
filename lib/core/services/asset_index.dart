import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle, AssetManifest;

import '../models/content_meta.dart';
import '../markdown/front_matter.dart';
import 'crypto_service.dart';

/// Loads the content index.
///
/// In Release mode: reads `assets/build/content_index.json` (fast).
/// In Debug mode: reads `AssetManifest` to find all `assets/contents/...` files,
/// decrypts them on the fly to read FrontMatter, and rebuilds the index in-memory.
/// This allows "Hot Restart" to pick up new files without running `tools/encrypt_content.dart`.
Future<List<ContentMeta>> loadContentIndex() async {
  // 1. Try to load the static index first (always good to have)
  List<ContentMeta> staticList = [];
  try {
    final jsonStr = await rootBundle.loadString(
      'assets/build/content_index.json',
    );
    final decoded = jsonDecode(jsonStr) as List<dynamic>;
    for (final item in decoded) {
      final map = item as Map<String, dynamic>;
      // Optional: only use English entries for now
      final lang = map['lang']?.toString();
      if (lang != null && lang != 'en') continue;
      staticList.add(ContentMeta.fromJson(map));
    }
  } catch (e) {
    debugPrint("⚠️ Could not load static content_index.json: $e");
  }

  // 2. If in Debug mode, perform dynamic discovery to catch new/modified files
  if (kDebugMode) {
    try {
      final dynamicList = await _discoverAssetsFromManifest();

      // Merge: Use dynamic versions if available (they might be newer),
      // but simplistic approach: Just use dynamic list if it found anything,
      // as it represents the true state of the assets folder.
      if (dynamicList.isNotEmpty) {
        debugPrint("🚀 [Debug] Discovered ${dynamicList.length} items dynamically.");
        staticList = dynamicList;
      }
    } catch (e) {
      debugPrint("⚠️ Dynamic asset discovery failed: $e");
    }
  }

  // 3. Sort
  staticList.sort((a, b) {
    final ad = a.date ?? DateTime(1970);
    final bd = b.date ?? DateTime(1970);
    return bd.compareTo(ad);
  });

  return staticList;
}

/// Scans AssetManifest for `assets/contents/**.enc`, decrypts header, parses FM.
Future<List<ContentMeta>> _discoverAssetsFromManifest() async {
  final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  final assetPaths = manifest.listAssets();

  final contentPaths = assetPaths.where((path) {
    return path.startsWith('assets/contents/') &&
           (path.endsWith('.md.enc') || path.endsWith('.md'));
           // Support .md if we ever support unencrypted in dev,
           // but currently system relies on .enc
  }).toList();

  final results = <ContentMeta>[];

  for (final path in contentPaths) {
    try {
      // We must load the file to parse front-matter
      // This is slow for 100s of files, but acceptable for Debug+Local
      final dynamic data = await rootBundle.load(path);
      final bytes = data.buffer.asUint8List();

      String markdownBody;
      if (path.endsWith('.enc')) {
         markdownBody = await CryptoService.decryptBytesToMarkdown(bytes);
      } else {
         markdownBody = utf8.decode(bytes);
      }

      final parsed = parseFrontMatter(markdownBody);

      // We rely on path structure for some metadata if missing
      // e.g. assets/contents/en/blog/my-post.md.enc
      // segments: [assets, contents, en, blog, my-post.md.enc]
      final segments = path.split('/');
      final filename = segments.last;
      final slug = filename.replaceAll('.md.enc', '').replaceAll('.md', '');

      // type is the folder name before the file (e.g. 'blog')
      String type = 'page';
      if (segments.length >= 4) {
         type = segments[segments.length - 2];
      }

      // If front-matter has no slug, use filename
      var meta = parsed.attributes;
      if (!meta.containsKey('slug')) meta['slug'] = slug;
      if (!meta.containsKey('type')) meta['type'] = type;
      if (!meta.containsKey('path')) meta['path'] = path;

      // Default lang to 'en' if not specified, or infer from path?
      // Path: assets/contents/en/...
      if (!meta.containsKey('lang') && segments.contains('en')) {
        meta['lang'] = 'en';
      }

      // Use the generic factory
      final cm = ContentMeta.fromJson(meta);
      results.add(cm);

    } catch (e) {
      debugPrint("Error parsing $path: $e");
    }
  }

  return results;
}
