import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../core/utils/visibility.dart';
import 'visibility_badge.dart';

class DetailHeader extends StatelessWidget {
  final dynamic meta;
  const DetailHeader({super.key, required this.meta});

  @override
  Widget build(BuildContext context) {
    final title = (meta.title as String?) ?? (meta.slug as String?) ?? '';
    final type = (meta.type as String?) ?? '';
    final slug = (meta.slug as String?) ?? '';
    final isPrivate = metaIsPrivate(meta);

    final parentRoute = _parentIndexFor(type, slug);

    // Optional: show a small, locale-formatted date if available on the meta
    final DateTime? date = meta.date is DateTime ? meta.date as DateTime : null;
    final String? dateText = date == null
        ? null
        : _formatDateLocalized(context, date);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(
                  context,
                ).pop(); // smooth back when shown inline / pushed
              } else {
                context.go(
                  parentRoute,
                ); // deep link direct entry → go to section index
              }
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main title
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (dateText != null) ...[
                  const SizedBox(height: 2),
                  Text(dateText, style: Theme.of(context).textTheme.bodySmall),
                ],
              ],
            ),
          ),
          VisibilityBadge(isPrivate: isPrivate),
        ],
      ),
    );
  }

  /// Central place to decide where the Back button should go for each type.
  /// Keeps parity with ContentCard’s route policy.
  String _parentIndexFor(String type, String slug) {
    switch (type) {
      case 'blog':
        return '/blog';
      case 'timeline':
        return '/timeline';
      case 'people':
        return '/people';
      case 'project':
        return '/projects';
      case 'lab':
        return '/labs';
      case 'library':
        return '/library';
      case 'meta':
        return '/meta';
      case 'foundation':
        return '/foundation';
      case 'page':
      default:
        // Pages don’t have a “section index”. For common pages, treat Home as the parent.
        // If you introduce a pages index later, change this to '/pages'.
        return '/';
    }
  }

  String _formatDateLocalized(BuildContext context, DateTime d) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).format(d);
    // Example outputs: "Nov 2, 2025" / locale-appropriate variants
  }
}
