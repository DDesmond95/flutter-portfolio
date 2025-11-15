import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../app/config.dart';
import '../../core/models/content_meta.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/content_service.dart';
import '../../core/utils/l10n.dart';
import '../../core/utils/responsive.dart';
import '../../widgets/content_card.dart';

class MetaIndexPage extends StatefulWidget {
  final String? initialCategory;

  const MetaIndexPage({super.key, this.initialCategory});

  @override
  State<MetaIndexPage> createState() => _MetaIndexPageState();
}

class _MetaIndexPageState extends State<MetaIndexPage> {
  String? _activeCategory;

  @override
  void initState() {
    super.initState();
    _activeCategory = widget.initialCategory; // ← sync URL on first load
  }

  @override
  void didUpdateWidget(covariant MetaIndexPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCategory != widget.initialCategory) {
      setState(() => _activeCategory = widget.initialCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cfg = context.read<AppConfig>();
    if (!cfg.showMeta) {
      return Center(child: Text(context.l10n.metaDisabled));
    }

    final svc = context.watch<ContentService>();
    final auth = context.watch<AuthService>();
    final text = Theme.of(context).textTheme;
    final allItems = svc.listByType('meta', publicOnly: !auth.isLoggedIn);
    if (allItems.isEmpty) {
      return Center(child: Text(context.l10n.philosophyEmpty));
    }

    final categories = _derivePhilosophyCategories(allItems);
    final filtered = _filterByCategory(allItems, _activeCategory);

    return ListView(
      padding: EdgeInsets.all(context.pagePadding),
      children: [
        // Section Title
        Text(
          context.l10n.navPhilosophy,
          style: text.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.12,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          context.l10n.philosophySectionSubtitle,
          style: text.bodyLarge?.copyWith(
            color: text.bodySmall?.color?.withValues(alpha: 0.85),
            height: 1.45,
          ),
        ),

        const SizedBox(height: 20),

        // Dynamic category chips
        if (categories.isNotEmpty)
          _CategoryChips(
            categories: categories,
            active: _activeCategory,
            onChanged: (v) {
              setState(() => _activeCategory = v);

              final base = '/meta';
              if (v == null) {
                context.go(base);
              } else {
                context.go('$base?f=$v');
              }
            },
          ),

        if (categories.isNotEmpty) const SizedBox(height: 24),

        // Cards
        for (final m in filtered) ...[
          ContentCard(meta: m),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

/// Collect unique `philosophy:*` tags.
List<String> _derivePhilosophyCategories(List<ContentMeta> items) {
  final s = <String>{};
  for (final m in items) {
    for (final t in m.tags) {
      final tag = t.toString().trim();
      if (tag.startsWith('philosophy:')) s.add(tag);
    }
  }
  final list = s.toList();
  list.sort((a, b) => _labelForCategory(a).compareTo(_labelForCategory(b)));
  return list;
}

/// Convert "philosophy:mind-focus" → "Mind Focus"
String _labelForCategory(String tag) {
  final raw = tag.split(':').last;
  return raw
      .split(RegExp(r'[-_]'))
      .map((p) => p.isEmpty ? '' : p[0].toUpperCase() + p.substring(1))
      .join(' ')
      .trim();
}

/// Filter items
List<ContentMeta> _filterByCategory(
  List<ContentMeta> items,
  String? categoryTag,
) {
  if (categoryTag == null) return items;
  return items
      .where((m) => m.tags.any((t) => t.toString().trim() == categoryTag))
      .toList();
}

class _CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String? active;
  final ValueChanged<String?> onChanged;

  const _CategoryChips({
    required this.categories,
    required this.active,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(
            label: Text(context.l10n.workFilterAll, style: text.bodyMedium),
            selected: active == null,
            onSelected: (_) => onChanged(null),
          ),
          for (final cat in categories) ...[
            const SizedBox(width: 10),
            ChoiceChip(
              label: Text(_labelForCategory(cat), style: text.bodyMedium),
              selected: active == cat,
              onSelected: (_) => onChanged(cat),
            ),
          ],
        ],
      ),
    );
  }
}
