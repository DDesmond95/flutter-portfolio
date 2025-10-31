// lib/pages/markdown_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../design/motion.dart';
import '../services/markdown_loader.dart';

class MarkdownPage extends StatelessWidget {
  const MarkdownPage({
    super.key,
    required this.assetPath,
    required this.explicitTitle,
    this.maxWidth = 900,
  });

  final String assetPath;
  final String? explicitTitle;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: MarkdownLoader.load(assetPath),
      builder: (context, snap) {
        final theme = Theme.of(context);
        final body = snap.data ?? '';
        final title = explicitTitle ?? MarkdownLoader.extractH1(body) ?? 'Page';

        return Title(
          title: '$title | Portfolio',
          color: theme.colorScheme.primary,
          child: Scaffold(
            body: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                    child: snap.connectionState == ConnectionState.done
                        ? AppMotion.fadeIn(
                            context,
                            duration: AppMotion.medium,
                            child: Markdown(
                              data: body,
                              softLineBreak: true,
                              selectable: false,
                              onTapLink: (text, href, title) {
                                if (href == null) return;
                                launchUrl(
                                  Uri.parse(href),
                                  mode: LaunchMode.platformDefault,
                                );
                              },
                              imageDirectory: null,
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(16),
                            child: LinearProgressIndicator(),
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
