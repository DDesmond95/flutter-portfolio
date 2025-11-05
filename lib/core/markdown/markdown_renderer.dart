import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/responsive.dart';

class MarkdownView extends StatelessWidget {
  final String data;
  const MarkdownView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // clamp returns num → cast to double; use double literals
        final double maxW = context.readableMaxWidth
            .clamp(0.0, constraints.maxWidth)
            .toDouble();

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW, minWidth: 1.0),
            child: Markdown(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              data: data,
              selectable: true,
              softLineBreak: true,
              onTapLink: (text, href, title) async {
                if (href == null) return;
                final uri = Uri.parse(href);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.platformDefault);
                }
              },
              imageBuilder: (uri, title, alt) {
                final p = uri.toString().startsWith('/assets/')
                    ? uri.toString().substring(1)
                    : uri.toString();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 1.0,
                      minHeight: 1.0,
                      maxWidth: double.infinity,
                    ),
                    child: Image.asset(
                      p,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                );
              },
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                  .copyWith(
                    textScaler: const TextScaler.linear(1.05),
                    h1Padding: const EdgeInsets.only(top: 20, bottom: 8),
                    h2Padding: const EdgeInsets.only(top: 16, bottom: 8),
                    h3Padding: const EdgeInsets.only(top: 12, bottom: 6),
                    pPadding: const EdgeInsets.only(top: 6, bottom: 6),
                  ),
            ),
          ),
        );
      },
    );
  }
}
