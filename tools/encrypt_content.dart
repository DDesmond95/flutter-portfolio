// tools/encrypt_content.dart
//
// Encrypt all Markdown files from assets/contents-src into assets/contents
// using AES-GCM (256-bit).
//
// Layout:
//   Source (plaintext): assets/contents-src/<lang>/<type>/file.md
//   Output (cipher):    assets/contents/<lang>/<type>/file.md.enc
//   Index JSON:         assets/build/content_index.json
//
// Usage:
//   dart run tools/encrypt_content.dart
//
// Optional args:
//   --src-dir=assets/contents-src --out-dir=assets/contents

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// === CONFIG ===

// Default locations; can be overridden via CLI flags.
const String kDefaultSrcDir = 'assets/contents-src';
const String kDefaultOutDir = 'assets/contents';
const String kIndexOutputPath = 'assets/build/content_index.json';

// 32-byte hex key for AES-256.
// For now we hard-code a sample; you should replace this with your own value.
// Generate one with e.g. `python - << "EOF" ...` or any hex generator.
const String kHexKey =
    '00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff';

// AES-GCM with 256-bit key.
final AesGcm _algorithm = AesGcm.with256bits();

// We’ll use 12-byte nonces (standard for GCM).
const int kNonceLength = 12;
// GCM MAC length is 16 bytes by default.
const int kMacLength = 16;

/// === MODEL FOR INDEX ===

class ContentIndexEntry {
  final String
  path; // e.g. en/blog/calm-technology.md.enc (relative to assets/contents)
  final String lang;
  final String type; // blog / foundation / labs / ...
  final String slug;
  final String title;
  final String visibility; // public / private
  final String? date;
  final String? summary;
  final List<String> tags;
  final String? thumbnail;
  final String? readingTime;

  ContentIndexEntry({
    required this.path,
    required this.lang,
    required this.type,
    required this.slug,
    required this.title,
    required this.visibility,
    required this.date,
    required this.summary,
    required this.tags,
    required this.thumbnail,
    required this.readingTime,
  });

  Map<String, Object?> toJson() => {
    'path': path,
    'lang': lang,
    'type': type,
    'slug': slug,
    'title': title,
    'visibility': visibility,
    'date': date,
    'summary': summary,
    'tags': tags,
    'thumbnail': thumbnail,
    'reading_time': readingTime,
  };
}

/// === UTILS ===

Uint8List _hexToBytes(String hex) {
  final clean = hex.replaceAll(RegExp(r'[^0-9a-fA-F]'), '');
  if (clean.length % 2 != 0) {
    throw ArgumentError('Hex key length must be even');
  }
  final result = Uint8List(clean.length ~/ 2);
  for (var i = 0; i < clean.length; i += 2) {
    final byteStr = clean.substring(i, i + 2);
    result[i ~/ 2] = int.parse(byteStr, radix: 16);
  }
  return result;
}

Future<SecretKey> _loadSecretKey() async {
  final keyBytes = _hexToBytes(kHexKey);
  if (keyBytes.length != 32) {
    throw StateError('kHexKey must decode to 32 bytes for AES-256.');
  }
  return SecretKey(keyBytes);
}

/// Encrypts [plainText] (UTF-8) using AES-GCM.
/// Returns: nonce(12) + cipherText + mac(16) as bytes.
Future<Uint8List> _encryptString(String plainText, SecretKey key) async {
  final plainBytes = utf8.encode(plainText);

  // In cryptography 2.x, newNonce() returns List<int>, not Nonce.
  final nonce = _algorithm.newNonce(); // List<int> of length 12 by default.

  final secretBox = await _algorithm.encrypt(
    plainBytes,
    secretKey: key,
    nonce: nonce,
  );

  final cipher = secretBox.cipherText;
  final macBytes = secretBox.mac.bytes;

  final out = Uint8List(kNonceLength + cipher.length + kMacLength);
  out.setRange(0, kNonceLength, nonce);
  out.setRange(kNonceLength, kNonceLength + cipher.length, cipher);
  out.setRange(kNonceLength + cipher.length, out.length, macBytes);

  return out;
}

/// Parses front-matter and body from a markdown file.
/// Assumes front-matter fenced by --- lines.
Map<String, dynamic> _parseFrontMatter(String content) {
  if (!content.startsWith('---')) {
    return {'frontMatter': <String, dynamic>{}, 'body': content};
  }

  final lines = LineSplitter.split(content).toList();
  if (lines.length < 3) {
    return {'frontMatter': <String, dynamic>{}, 'body': content};
  }

  int endIndex = -1;
  for (var i = 1; i < lines.length; i++) {
    if (lines[i].trim() == '---') {
      endIndex = i;
      break;
    }
  }

  if (endIndex == -1) {
    return {'frontMatter': <String, dynamic>{}, 'body': content};
  }

  final yamlText = lines.sublist(1, endIndex).join('\n');
  final body = lines.sublist(endIndex + 1).join('\n');

  final yamlDoc = loadYaml(yamlText);
  final Map<String, dynamic> fm = {};

  if (yamlDoc is YamlMap) {
    for (final key in yamlDoc.keys) {
      fm[key.toString()] = yamlDoc[key];
    }
  }

  return {'frontMatter': fm, 'body': body};
}

/// Derives (lang, type, slug) from a path like:
/// assets/contents-src/en/blog/calm-technology.md
Map<String, String> _inferPathInfo(String srcRoot, File file) {
  final relative = p.relative(file.path, from: srcRoot).replaceAll('\\', '/');
  // relative: en/blog/calm-technology.md
  final parts = relative.split('/');
  if (parts.length < 3) {
    throw StateError('Unexpected content path structure: $relative');
  }

  final lang = parts[0];
  final type = parts[1];
  final filename = parts.last;
  final slug = p.basenameWithoutExtension(filename);

  return {'relative': relative, 'lang': lang, 'type': type, 'slug': slug};
}

/// === MAIN WORK ===

Future<void> _encryptAll({
  required String srcDir,
  required String outDir,
}) async {
  final key = await _loadSecretKey();

  final src = Directory(srcDir);
  if (!src.existsSync()) {
    stderr.writeln('Source directory not found: $srcDir');
    exitCode = 1;
    return;
  }

  final out = Directory(outDir);
  if (!out.existsSync()) {
    out.createSync(recursive: true);
  }

  final indexEntries = <ContentIndexEntry>[];

  final mdFiles = src
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.toLowerCase().endsWith('.md'))
      .toList();

  if (mdFiles.isEmpty) {
    stdout.writeln('No .md files found under $srcDir');
  }

  for (final file in mdFiles) {
    final info = _inferPathInfo(srcDir, file);
    final lang = info['lang']!;
    final type = info['type']!;
    final slug = info['slug']!;
    final relativeSrc = info['relative']!;

    stdout.writeln('Encrypting: $relativeSrc');

    final raw = await file.readAsString();
    final parsed = _parseFrontMatter(raw);
    final fm = parsed['frontMatter'] as Map<String, dynamic>;
    final body = parsed['body'] as String;

    // Normalise some front-matter fields.
    final title = (fm['title'] ?? slug).toString();
    final visibility = (fm['visibility'] ?? 'public').toString();
    final date = fm['date']?.toString();
    final summary = fm['summary']?.toString();
    final thumbnail = fm['thumbnail']?.toString();
    final readingTime = fm['reading_time']?.toString();

    final tagsRaw = fm['tags'];
    final tags = <String>[];
    if (tagsRaw is Iterable) {
      tags.addAll(tagsRaw.map((e) => e.toString()));
    }

    // Reconstruct markdown with front-matter as text, so runtime has it as well
    // (you can choose to drop front-matter from encrypted body if you prefer).
    final reconstructed = StringBuffer()..writeln('---');
    fm.forEach((key, value) {
      if (value is Iterable) {
        final listStr = '[${value.map((e) => e.toString()).join(', ')}]';
        reconstructed.writeln('$key: $listStr');
      } else {
        reconstructed.writeln('$key: $value');
      }
    });
    reconstructed
      ..writeln('---')
      ..writeln(body);

    final encryptedBytes = await _encryptString(reconstructed.toString(), key);

    // Output path: same relative path but under outDir with .md.enc extension.
    final outRelative = p.setExtension(relativeSrc, '.md.enc');
    final outFullPath = p.join(outDir, outRelative);
    final outFile = File(outFullPath);
    outFile.parent.createSync(recursive: true);
    await outFile.writeAsBytes(encryptedBytes);

    indexEntries.add(
      ContentIndexEntry(
        path: outRelative.replaceAll('\\', '/'),
        lang: lang,
        type: type,
        slug: slug,
        title: title,
        visibility: visibility,
        date: date,
        summary: summary,
        tags: tags,
        thumbnail: thumbnail,
        readingTime: readingTime,
      ),
    );
  }

  // Sort index for stable output (by lang, type, date desc, then slug).
  indexEntries.sort((a, b) {
    final c1 = a.lang.compareTo(b.lang);
    if (c1 != 0) return c1;
    final c2 = a.type.compareTo(b.type);
    if (c2 != 0) return c2;
    // date descending if both have dates.
    if (a.date != null && b.date != null) {
      final d2 = b.date!.compareTo(a.date!);
      if (d2 != 0) return d2;
    }
    return a.slug.compareTo(b.slug);
  });

  final indexDir = Directory(p.dirname(kIndexOutputPath));
  if (!indexDir.existsSync()) {
    indexDir.createSync(recursive: true);
  }

  final indexJson = jsonEncode(indexEntries.map((e) => e.toJson()).toList());
  await File(kIndexOutputPath).writeAsString(indexJson);

  stdout.writeln(
    'Done. Encrypted ${indexEntries.length} files → $outDir and wrote index → $kIndexOutputPath',
  );
}

void main(List<String> args) async {
  String srcDir = kDefaultSrcDir;
  String outDir = kDefaultOutDir;

  for (final arg in args) {
    if (arg.startsWith('--src-dir=')) {
      srcDir = arg.substring('--src-dir='.length);
    } else if (arg.startsWith('--out-dir=')) {
      outDir = arg.substring('--out-dir='.length);
    }
  }

  await _encryptAll(srcDir: srcDir, outDir: outDir);
}
