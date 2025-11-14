import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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

    final subtitlePieces = <String>[
      if (date != null) _formatDateLocalized(context, date),
      if (summary != null && summary.isNotEmpty) summary,
    ];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go(_detailRouteFor(type, slug)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: dense ? 8 : 12,
            vertical: dense ? 6 : 10,
          ),
          child: Row(
            crossAxisAlignment: dense
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              _Thumb(meta: meta),
              const SizedBox(width: 12),
              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + visibility badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(width: 8),
                        VisibilityBadge(isPrivate: isPrivate),
                      ],
                    ),
                    if (subtitlePieces.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        subtitlePieces.join('  •  '),
                        maxLines: dense ? 2 : 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Route mapping is centralized here to avoid mismatches across the app.
  String _detailRouteFor(String type, String slug) {
    switch (type) {
      case 'blog':
        return '/blog/$slug';
      case 'timeline':
        return '/timeline/$slug';
      case 'people':
        return '/people/$slug';
      case 'project':
        return '/projects/$slug';
      case 'lab':
        return '/labs/$slug';
      case 'library':
        return '/library/$slug';
      case 'meta':
        return '/meta/$slug';
      case 'foundation':
        return '/foundation/$slug';
      case 'page':
      default:
        switch (slug) {
          case 'home':
            return '/';
          case 'about':
            return '/pages/about';
          case 'services':
            return '/services';
          case 'contact':
            return '/contact';
          case 'resume':
            return '/resume';
          default:
            return '/pages/$slug';
        }
    }
  }

  String _formatDateLocalized(BuildContext context, DateTime d) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).format(d);
  }
}

class _Thumb extends StatelessWidget {
  final dynamic meta;
  const _Thumb({required this.meta});

  @override
  Widget build(BuildContext context) {
    final String? t = (meta.thumbnail as String?);
    final double size = 56;

    if (t == null || t.isEmpty) {
      return _placeholder(size);
    }

    final path = t.startsWith('/assets/') ? t.substring(1) : t;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => _placeholder(size),
      ),
    );
  }

  Widget _placeholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.insert_drive_file_outlined, size: 20),
    );
  }
}
