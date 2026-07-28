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
  List<ContentMeta> staticList = [];

  void add(dynamic item) {
    if (item is Map<String, dynamic>) {
      if (item['slug'] is String) {
        item['slug'] = (item['slug'] as String).replaceFirst(RegExp(r'^\d+[-_]?'), '');
      }
      staticList.add(ContentMeta.fromJson(item));
    }
  }

  // 1. Try static index from build tool
  try {
    final indexJson = await rootBundle.loadString('assets/build/content_index.json');
    final List<dynamic> list = json.decode(indexJson);
    list.forEach(add);
  } catch (e) {
    // Try legacy path
    try {
      final indexJson = await rootBundle.loadString('assets/index.json');
      final List<dynamic> list = json.decode(indexJson);
      for (final item in list) {
        staticList.add(ContentMeta.fromJson(item as Map<String, dynamic>));
      }
    } catch (_) {
      debugPrint('Static index not found.');
    }
  }

  // 2. Discover dynamically (Debug mode OR if static index missing)
  if (kDebugMode || staticList.isEmpty) {
    // Only run if we actually need it
    if (staticList.isEmpty) {
      try {
        final dynamicList = await _discoverAssetsFromManifest();
        if (dynamicList.isNotEmpty) {
          staticList = dynamicList;
        }
      } catch (e) {
        debugPrint("⚠️ Dynamic asset discovery failed: $e");
      }
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
      var slug = filename.replaceAll('.md.enc', '').replaceAll('.md', '');
      slug = slug.replaceFirst(RegExp(r'^\d+[-_]?'), '');

      // type is the folder name before the file (e.g. 'blog')
      String type = 'page';
      if (segments.length >= 4) {
         type = segments[segments.length - 2];
      }

      // If front-matter has no slug, use filename
      var meta = parsed.meta;
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
