// features/timeline/detail_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/content_service.dart';
import '../../core/markdown/markdown_renderer.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/visibility.dart';
import '../../core/services/auth_service.dart';
import '../../widgets/lock_banner.dart';
import '../../core/utils/l10n.dart';
import '../../core/services/content_localized.dart';

class TimelineDetailPage extends StatelessWidget {
  final String slug;
  const TimelineDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<ContentService>();
    final auth = context.watch<AuthService>();

    return FutureBuilder<void>(
      future: svc.ensureLoaded(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final normalized = _normalizeSlug(slug);
        final meta = svc.findByTypeAndSlug('timeline', normalized);

        if (meta == null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(context.pagePadding),
              child: Text(context.l10n.notFoundGeneric),
            ),
          );
        }

        final isPrivate = metaIsPrivate(meta);
        if (isPrivate && !auth.isLoggedIn) {
          return Padding(
            padding: EdgeInsets.all(context.pagePadding),
            child: LockBanner(type: 'timeline', slug: normalized),
          );
        }

        return FutureBuilder<String>(
          future: svc.loadBodyLocalized(
            meta.path,
            Localizations.localeOf(context),
          ),
          builder: (context, bodySnap) {
            if (!bodySnap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: SingleChildScrollView(
                key: ValueKey(meta.slug),
                padding: EdgeInsets.all(context.pagePadding),
                child: MarkdownView(data: bodySnap.data!),
              ),
            );
          },
        );
      },
    );
  }

  String _normalizeSlug(String raw) {
    var s = raw.trim();
    final looksLikePath = s.contains('/contents/') || s.startsWith('assets/');
    if (looksLikePath) {
      final parts = s.split('/');
      s = parts.isNotEmpty ? parts.last : s;
    }
    if (s.endsWith('.md')) s = s.substring(0, s.length - 3);
    return s;
  }
}
