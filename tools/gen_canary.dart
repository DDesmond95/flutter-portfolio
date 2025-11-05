// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    print('Usage: dart run tools/gen_canary.dart "<your-passphrase>"');
    return;
  }
  final passphrase = args.first;

  final rnd = Random.secure();
  List<int> randBytes(int n) => List<int>.generate(n, (_) => rnd.nextInt(256));

  final salt = randBytes(16); // 128-bit salt
  final nonce = randBytes(12); // AES-GCM standard nonce

  final pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 150000,
    bits: 256,
  );
  final key = await pbkdf2.deriveKeyFromPassword(
    password: passphrase,
    nonce: salt,
  );

  final algo = AesGcm.with256bits();
  final box = await algo.encrypt(
    utf8.encode('ok'),
    secretKey: key,
    nonce: nonce,
  );

  print('Add these to your .env:');
  print('AUTH_CANARY_SALT=${base64Encode(salt)}');
  print('AUTH_CANARY_NONCE=${base64Encode(box.nonce)}');
  print('AUTH_CANARY_DATA=${base64Encode(box.cipherText)}');
  print('AUTH_CANARY_MAC=${base64Encode(box.mac.bytes)}');
}
