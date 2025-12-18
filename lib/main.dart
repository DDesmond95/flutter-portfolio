import 'package:flutter/material.dart';
import 'package:cryptography_flutter/cryptography_flutter.dart'; // Speed
import 'src/url_strategy_stub.dart'
    if (dart.library.html) 'src/url_strategy_web.dart';
import 'app/app.dart';
// 新增导入
import 'app/config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable native/web-crypto acceleration
  await FlutterCryptography.enable();

  // 新增：加载环境变量（从.env文件）
  await dotenv.load(fileName: ".env");

  // GitHub Pages: hash routing to avoid server rewrites (no-op on non-web)
  setHashUrlStrategy();

  // 验证必要的环境变量（可选，但推荐）
  try {
    // 仅验证存在性，不读取具体值
    AppConfig.authCanarySalt;
    AppConfig.authCanaryNonce;
    AppConfig.authCanaryData;
    AppConfig.authCanaryMac;
  } catch (e) {
    debugPrint("警告：缺少必要的环境变量 - $e");
  }

  runApp(const PortfolioApp());
}
