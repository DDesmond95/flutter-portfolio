import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart'
    show setUrlStrategy, HashUrlStrategy;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Web-friendly: wrap in try; dotenv will be no-op if asset not bundled
  try {
    await dotenv.load(fileName: '.env', isOptional: true, mergeWith: const {});
  } catch (_) {}

  // GitHub Pages: hash routing to avoid server rewrites
  setUrlStrategy(const HashUrlStrategy());

  runApp(const PortfolioApp());
}
