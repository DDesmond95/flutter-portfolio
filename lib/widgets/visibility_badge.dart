// lib/widgets/visibility_badge.dart
import 'package:flutter/material.dart';

class VisibilityBadge extends StatelessWidget {
  final bool isPrivate;
  const VisibilityBadge({super.key, required this.isPrivate});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = isPrivate ? scheme.error : scheme.secondary;

    // withOpacity() is deprecated → use withValues(alpha: ...)
    final bg = base.withValues(alpha: 0.10);
    final border = base.withValues(alpha: 0.40);

    final label = isPrivate ? 'Private' : 'Public';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: TextStyle(color: base, fontSize: 12)),
    );
  }
}
