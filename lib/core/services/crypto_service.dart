import 'dart:convert';
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
      mac: Mac
          .empty, // MAC is embedded in data for AES-GCM SecretBox in this package
    );

    final clear = await algorithm.decrypt(secretBox, secretKey: secretKey);

    return utf8.decode(clear);
  }
}
