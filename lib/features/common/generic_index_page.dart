import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/models/content_meta.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/content_service.dart';
import '../../core/utils/l10n.dart';
import '../../core/utils/responsive.dart';
import '../../widgets/content_card.dart';
import '../../widgets/section_header.dart'; // Reused for consistency if desired, or manual text

class GenericIndexPage extends StatefulWidget {
  final String contentType; // e.g. 'library', 'people', 'meta', 'foundation'
  final String title;
  final String subtitle;
  final String? initialFilterTag;
  final String emptyMessage;
  final String filterPrefix; // e.g. 'library:', 'people:', 'philosophy:'

  const GenericIndexPage({
    super.key,
    required this.contentType,
    required this.title,
    required this.subtitle,
    required this.filterPrefix,
    this.initialFilterTag,
    this.emptyMessage = 'No entries found.',
  });

  @override
  State<GenericIndexPage> createState() => _GenericIndexPageState();
}

class _GenericIndexPageState extends State<GenericIndexPage> {
  String? _activeCategory; // The full tag string, e.g. "library:reading-list"

  @override
  void initState() {
    super.initState();
    _activeCategory = widget.initialFilterTag;
  }

  @override
  void didUpdateWidget(covariant GenericIndexPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialFilterTag != widget.initialFilterTag) {
      if (widget.initialFilterTag != null) {
        setState(() => _activeCategory = widget.initialFilterTag);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<ContentService>();
    final auth = context.watch<AuthService>();
    final text = Theme.of(context).textTheme;

    return FutureBuilder(
      future: svc.ensureLoaded(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final allItems = svc.listByType(
          widget.contentType,
          publicOnly: !auth.isLoggedIn,
        );

        if (allItems.isEmpty) {
          return Center(child: Text(widget.emptyMessage));
        }

        // 1. Derive categories
        final categories = _deriveCategories(allItems, widget.filterPrefix);

        // 2. Filter items
        final filtered = _filterByCategory(allItems, _activeCategory);

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(context.pagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: text.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.subtitle,
                      style: text.bodyLarge?.copyWith(
                        color: text.bodySmall?.color?.withValues(alpha: 0.85),
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Chips
                    if (categories.isNotEmpty)
                      _CategoryChips(
                        categories: categories,
                        active: _activeCategory,
                        prefix: widget.filterPrefix,
                        onChanged: (v) {
                          _updateRoute(v);
                        },
                      ),
                  ],
                ),
              ),
            ),
            if (filtered.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text(widget.emptyMessage)),
              )
            else
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.pagePadding,
                  vertical: 4,
                ),
                sliver: SliverList.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (context, i) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => ContentCard(meta: filtered[i]),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        );
      },
    );
  }

  void _updateRoute(String? tag) {
    setState(() => _activeCategory = tag);

    final uri = GoRouterState.of(context).uri;
    // We want to preserve the current path but update the query param 'cat' or 'f'
    // Actually, 'meta' uses 'f', others use 'cat'.
    // To be consistent, let's standardize on 'f' for filter, or support both?
    // The previous implementation used 'cat' for Library/People and 'f' for Meta/Work.
    // Let's settle on using query parameters in a generic way or just stick to one key.
    // However, the Router determines the key.
    // A simple approach: use query parameter 'f' for all generic pages going forward.

    final newPath = uri.path;
    if (tag == null) {
      context.go(newPath);
    } else {
      context.go('$newPath?f=$tag');
    }
  }

  /// Collect unique tags starting with prefix
  List<String> _deriveCategories(List<ContentMeta> items, String prefix) {
    final s = <String>{};
    for (final m in items) {
      for (final t in m.tags) {
        final tag = t.toString().trim();
        if (tag.startsWith(prefix)) s.add(tag);
      }
    }
    final list = s.toList();
    list.sort((a, b) => _labelForCategory(a, prefix).compareTo(_labelForCategory(b, prefix)));
    return list;
  }

  List<ContentMeta> _filterByCategory(
    List<ContentMeta> items,
    String? categoryTag,
  ) {
    if (categoryTag == null) return items;
    return items
        .where((m) => m.tags.any((t) => t.toString().trim() == categoryTag))
        .toList();
  }
}

class _CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String? active;
  final String prefix;
  final ValueChanged<String?> onChanged;

  const _CategoryChips({
    required this.categories,
    required this.active,
    required this.prefix,
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
            label: Text("All", style: text.bodyMedium),
            selected: active == null,
            onSelected: (_) => onChanged(null),
          ),
          for (final cat in categories) ...[
            const SizedBox(width: 10),
            ChoiceChip(
              label: Text(_labelForCategory(cat, prefix), style: text.bodyMedium),
              selected: active == cat,
              onSelected: (_) => onChanged(cat),
            ),
          ],
        ],
      ),
    );
  }
}

String _labelForCategory(String tag, String prefix) {
  // "library:reading-list" → "Reading List"
  // Remove prefix
  final raw = tag.startsWith(prefix) ? tag.substring(prefix.length) : tag;

  return raw
      .split(r'[-_]')
      .map((p) => p.isEmpty ? '' : p[0].toUpperCase() + p.substring(1))
      .join(' ')
      .trim();
}
