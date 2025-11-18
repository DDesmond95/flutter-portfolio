import 'package:flutter/material.dart';
import 'src/url_strategy_stub.dart'
    if (dart.library.html) 'src/url_strategy_web.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/app.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Web-friendly: wrap in try; dotenv will be no-op if asset not bundled
  try {
    await dotenv.load(
      fileName: kIsWeb ? 'assets/.env' : '.env',
      isOptional: true,
      mergeWith: const {},
    );
  } catch (_) {}

  // GitHub Pages: hash routing to avoid server rewrites (no-op on non-web)
  setHashUrlStrategy();

  runApp(const PortfolioApp());
}
