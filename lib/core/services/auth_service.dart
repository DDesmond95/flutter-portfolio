import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Client-side “login”:
/// - Stores a passphrase locally (shared_preferences → localStorage on web).
/// - Used to decrypt private markdown via PBKDF2 → AES-GCM.
/// - No server; no real credentials. Optional local canary validates UX only.
class AuthService extends ChangeNotifier {
  static const _kPassKey = 'auth.passphrase';
  String? _passphrase;

  String? get passphrase => _passphrase;
  bool get isLoggedIn => _passphrase != null && _passphrase!.isNotEmpty;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _passphrase = prefs.getString(_kPassKey);
    if (_passphrase != null && _passphrase!.isEmpty) _passphrase = null;
    notifyListeners();
  }

  Future<void> login(String passphrase) async {
    _passphrase = passphrase;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPassKey, passphrase);
    notifyListeners();
  }

  Future<void> logout() async {
    _passphrase = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kPassKey);
    notifyListeners();
  }

  /// Optional: validates a passphrase against a local canary in .env.
  /// Returns true if no canary is configured.
  Future<bool> validatePassphrase(String passphrase) async {
    final saltB64 = dotenv.maybeGet('AUTH_CANARY_SALT');
    final nonceB64 = dotenv.maybeGet('AUTH_CANARY_NONCE');
    final dataB64 = dotenv.maybeGet('AUTH_CANARY_DATA');
    final macB64 = dotenv.maybeGet('AUTH_CANARY_MAC'); // <-- NEW
    if (saltB64 == null ||
        nonceB64 == null ||
        dataB64 == null ||
        macB64 == null) {
      return true; // no canary configured → accept
    }

    try {
      final salt = base64Decode(saltB64);
      final nonce = base64Decode(nonceB64);
      final data = base64Decode(dataB64);
      final mac = Mac(base64Decode(macB64));

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
      final box = SecretBox(data, nonce: nonce, mac: mac); // <-- include mac
      final clear = await algo.decrypt(box, secretKey: key);

      return utf8.decode(clear) == 'ok';
    } catch (_) {
      return false;
    }
  }
}
