import 'package:flutter/material.dart';
import '../core/utils/visibility.dart';
import 'visibility_badge.dart';

class DetailHeader extends StatelessWidget {
  final dynamic meta;
  const DetailHeader({super.key, required this.meta});

  @override
  Widget build(BuildContext context) {
    final title = (meta.title as String?) ?? (meta.slug as String?) ?? '';
    final isPrivate = metaIsPrivate(meta);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          VisibilityBadge(isPrivate: isPrivate),
        ],
      ),
    );
  }
}
