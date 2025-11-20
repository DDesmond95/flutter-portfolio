import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

class CryptoService {
  // Simple detector: your private Markdown bodies begin with :::cipher
  bool isCiphertext(String body) => body.trimLeft().startsWith(':::cipher');

  // Expected envelope format inside body after ':::cipher' line:
  //
  // :::cipher
  // alg: AES-GCM
  // salt: <base64>
  // nonce: <base64>
  // data: <base64>
  //
  // (You can adapt this to your tooling as needed.)
  Future<String> decryptMarkdown(String body, String passphrase) async {
    final lines = const LineSplitter().convert(body.trim());
    if (lines.isEmpty || lines.first.trim() != ':::cipher') {
      return body;
    }
    final map = <String, String>{};
    for (final line in lines.skip(1)) {
      final i = line.indexOf(':');
      if (i <= 0) continue;
      final k = line.substring(0, i).trim();
      final v = line.substring(i + 1).trim();
      map[k] = v;
    }

    final salt = base64Decode(map['salt'] ?? '');
    final nonce = base64Decode(map['nonce'] ?? '');
    final data = base64Decode(map['data'] ?? '');

    // PBKDF2-HMAC-SHA256 → 32 bytes (AES-256)
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 150000,
      bits: 256,
    );

    final secretKey = await pbkdf2.deriveKeyFromPassword(
      password: passphrase,
      nonce: salt,
    );

    final algorithm = AesGcm.with256bits();
    final secretBox = SecretBox(
      data,
      nonce: nonce,
      mac: Mac.empty, // MAC is embedded in data for AES-GCM SecretBox here
    );

    final clear = await algorithm.decrypt(secretBox, secretKey: secretKey);

    return utf8.decode(clear);
  }

  // ============================================================
  // NEW: binary AES-GCM decryption for .md.enc assets
  // Layout from tools/encrypt_content.dart:
  //   nonce(12) | cipherText | mac(16)
  // ============================================================

  static const String _hexKey =
      '00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff';

  static final AesGcm _aead = AesGcm.with256bits();
  static SecretKey? _secretKey;

  static Uint8List _hexToBytes(String hex) {
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

  static Future<void> _ensureKey() async {
    if (_secretKey != null) return;
    final keyBytes = _hexToBytes(_hexKey);
    if (keyBytes.length != 32) {
      throw StateError('AES-256 key must be 32 bytes');
    }
    _secretKey = SecretKey(keyBytes);
  }

  /// Decrypts bytes stored as: nonce(12) | cipherText | mac(16)
  /// and returns the UTF-8 markdown string.
  static Future<String> decryptBytesToMarkdown(Uint8List encryptedBytes) async {
    await _ensureKey();

    const nonceLength = 12;
    const macLength = 16;

    if (encryptedBytes.length < nonceLength + macLength) {
      throw ArgumentError('Encrypted data too short');
    }

    final nonce = encryptedBytes.sublist(0, nonceLength);
    final macBytes = encryptedBytes.sublist(encryptedBytes.length - macLength);
    final cipherText = encryptedBytes.sublist(
      nonceLength,
      encryptedBytes.length - macLength,
    );

    final secretBox = SecretBox(cipherText, nonce: nonce, mac: Mac(macBytes));

    final clearBytes = await _aead.decrypt(secretBox, secretKey: _secretKey!);

    return utf8.decode(clearBytes);
  }
}
