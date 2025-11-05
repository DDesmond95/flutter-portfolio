import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<List<String>> listMarkdownAssets() async {
  final manifest = await rootBundle.loadString('AssetManifest.json');
  final map = json.decode(manifest) as Map<String, dynamic>;
  final all = map.keys.cast<String>();
  final md = all
      .where((p) => p.startsWith('assets/contents/') && p.endsWith('.md'))
      .toList();
  md.sort();
  return md;
}
