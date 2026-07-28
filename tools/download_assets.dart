import 'dart:io';

/// Map of { 'target_path': 'download_url' }
/// Removed successful legacy downloads to keep the list focused on active errors.
final downloads = {
  // Placeholder SVG for brand logo (using VectorLogoZone for reliable link)
  'assets/images/brand/logo.svg': 'https://www.vectorlogo.zone/logos/flutterio/flutterio-icon.svg',
};

Future<void> main() async {
  final client = HttpClient();

  print('🚀 Starting asset downloader...');

  for (final entry in downloads.entries) {
    final path = entry.key;
    final url = entry.value;
    final file = File(path);

    // Ensure parent directory exists
    final dir = file.parent;
    if (!dir.existsSync()) {
      print('📁 Creating directory: ${dir.path}');
      dir.createSync(recursive: true);
    }

    try {
      print('📥 Downloading $path...');
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // We use pipe to efficiently stream the download to the file
        await response.pipe(file.openWrite());
        print('✅ Saved $path');
      } else {
        print('❌ Failed $path: HTTP ${response.statusCode}');
        await response.drain();
      }
    } catch (e) {
      print('❌ Error downloading $path: $e');
    }
  }

  client.close();
  print('✨ Downloader finished.');
}
