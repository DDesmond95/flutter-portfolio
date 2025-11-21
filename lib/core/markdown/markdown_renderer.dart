import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/responsive.dart';

class MarkdownView extends StatefulWidget {
  final String data;
  const MarkdownView({super.key, required this.data});

  @override
  State<MarkdownView> createState() => _MarkdownViewState();
}

class _MarkdownViewState extends State<MarkdownView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        // clamp returns num → cast to double; use double literals
        final double maxW = context.readableMaxWidth
            .clamp(0.0, constraints.maxWidth)
            .toDouble();

        // Base stylesheet derived from current theme
        final baseSheet = MarkdownStyleSheet.fromTheme(theme);

        final styleSheet = baseSheet.copyWith(
          // Slightly larger overall scaling
          textScaler: const TextScaler.linear(1.10),

          // Headings aligned with your text system
          h1: textTheme.headlineLarge,
          h2: textTheme.headlineMedium,
          h3: textTheme.headlineSmall,
          h4: textTheme.titleLarge,
          h5: textTheme.titleMedium,
          h6: textTheme.titleSmall,

          // Paragraphs
          p: textTheme.bodyLarge,

          // Spacing around headings / paragraphs
          h1Padding: const EdgeInsets.only(top: 20, bottom: 12),
          h2Padding: const EdgeInsets.only(top: 16, bottom: 8),
          h3Padding: const EdgeInsets.only(top: 12, bottom: 6),
          h4Padding: const EdgeInsets.only(top: 10, bottom: 4),
          h5Padding: const EdgeInsets.only(top: 8, bottom: 2),
          h6Padding: const EdgeInsets.only(top: 6, bottom: 2),
          pPadding: const EdgeInsets.only(top: 6, bottom: 6),

          // Links
          a: textTheme.bodyMedium?.copyWith(
            color: colorScheme.primary,
            decoration: TextDecoration.underline,
            decorationThickness: 1.2,
          ),

          // Inline code
          code: textTheme.bodySmall?.copyWith(
            fontFamily: 'monospace',
            backgroundColor: colorScheme.surfaceContainerHigh.withValues(
              alpha: 0.6,
            ),
          ),

          // Code blocks
          codeblockDecoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant, width: 1),
          ),

          // Blockquotes
          blockquotePadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          blockquoteDecoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
            border: Border(
              left: BorderSide(color: colorScheme.primary, width: 3),
            ),
          ),

          // Lists
          listBulletPadding: const EdgeInsets.only(right: 4),
          // (other list-related properties keep base behaviour)

          // Tables
          tableHead: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          tableBorder: TableBorder.all(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
          tableCellsPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
        );

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW, minWidth: 1.0),
            child: Markdown(
              controller: _scrollController,
              shrinkWrap: true,
              data: widget.data,
              selectable: true,
              softLineBreak: true,
              styleSheet: styleSheet,
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
            ),
          ),
        );
      },
    );
  }
}
