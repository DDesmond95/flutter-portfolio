import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/utils/responsive.dart';
import '../core/utils/visibility.dart';
import 'visibility_badge.dart';

/// Assumes your meta model exposes:
/// - title, slug, type, date, summary, thumbnail
/// - path (for body fetch; not used here)
class ContentCard extends StatelessWidget {
  final dynamic meta;
  const ContentCard({super.key, required this.meta});

  @override
  Widget build(BuildContext context) {
    final dense = context.denseTiles;

    final String type = (meta.type as String?) ?? 'page';
    final String slug = (meta.slug as String?) ?? '';
    final String title = (meta.title as String?) ?? slug;
    final String? summary = (meta.summary as String?);
    final DateTime? date = meta.date is DateTime ? meta.date as DateTime : null;

    final bool isPrivate = metaIsPrivate(meta);
    final String routeBase = switch (type) {
      'blog' => '/blog',
      'project' => '/projects',
      'lab' => '/labs',
      'library' => '/library',
      'meta' => '/meta',
      'foundation' => '/foundation',
      _ => '/pages',
    };

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        dense: dense,
        minLeadingWidth: 56,
        leading: _thumb(meta),
        title: Row(
          children: [
            Expanded(
              child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 8),
            VisibilityBadge(isPrivate: isPrivate),
          ],
        ),
        subtitle: Text(
          [
            if (date != null) _formatDate(date),
            if (summary != null && summary.isNotEmpty) summary,
          ].join('  •  '),
          maxLines: dense ? 2 : 3,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => context.go('$routeBase/$slug'),
      ),
    );
  }

  Widget _thumb(dynamic meta) {
    final String? t = (meta.thumbnail as String?);
    if (t == null || t.isEmpty) {
      return const SizedBox(width: 56, height: 56);
    }
    final path = t.startsWith('/assets/') ? t.substring(1) : t;
    return Image.asset(
      path,
      width: 56,
      height: 56,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) =>
          const SizedBox(width: 56, height: 56),
    );
  }

  String _formatDate(DateTime d) {
    // Keep simple; you already have intl if you want locale formatting
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}
