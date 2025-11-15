import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/content_service.dart';
import '../../core/services/auth_service.dart';
import '../../core/models/content_meta.dart';
import '../../widgets/content_card.dart';
import '../../widgets/section_header.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/l10n.dart';

class LibraryIndexPage extends StatefulWidget {
  final String? initialFilter;
  const LibraryIndexPage({super.key, this.initialFilter});

  @override
  State<LibraryIndexPage> createState() => _LibraryIndexPageState();
}

class _LibraryIndexPageState extends State<LibraryIndexPage> {
  bool _loading = true;
  List<ContentMeta> _all = const [];
  List<ContentMeta> _filtered = const [];
  List<String> _categoryTags = const []; // e.g. ["library:reading-list"]
  String? _selectedCategoryTag; // null = "All entries"

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);

    final svc = context.read<ContentService>();
    final auth = context.read<AuthService>();

    await svc.ensureLoaded();
    final items = svc.listByType('library', publicOnly: !auth.isLoggedIn);

    // Discover category tags (start with "library:")
    final cats = <String>{};
    for (final m in items) {
      for (final t in m.tags) {
        final lower = t.toLowerCase().trim();
        if (lower.startsWith('library:')) {
          cats.add(lower);
        }
      }
    }
    final listCats = cats.toList()..sort();

    setState(() {
      _all = items;
      _categoryTags = listCats;
      final cat = widget.initialFilter;

      _selectedCategoryTag = cat;
      _filtered = _applyFilter(items, cat);

      _loading = false;
    });
  }

  List<ContentMeta> _applyFilter(
    List<ContentMeta> source,
    String? categoryTag,
  ) {
    if (categoryTag == null) return source;
    final target = categoryTag.toLowerCase();
    return source.where((m) {
      return m.tags.any((t) => t.toLowerCase().trim() == target);
    }).toList();
  }

  void _setCategory(String? tag) {
    setState(() {
      _selectedCategoryTag = tag;
      _filtered = _applyFilter(_all, tag);
    });

    if (tag == null) {
      context.go('/library');
    } else {
      context.go('/library?cat=$tag');
    }
  }

  String _labelForCategoryTag(String tag) {
    // "library:reading-list" → "Reading List"
    final raw = tag.toLowerCase().startsWith('library:')
        ? tag.substring('library:'.length)
        : tag;
    final withSpaces = raw.replaceAll('-', ' ');
    final words = withSpaces.split(' ').where((w) => w.isNotEmpty).toList();
    return words
        .map((w) => w[0].toUpperCase() + (w.length > 1 ? w.substring(1) : ''))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final items = _filtered;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SectionHeader(
            title: context.l10n.navLibrary,
            subtitle: context.l10n.librarySectionSubtitle,
            padding: EdgeInsets.fromLTRB(
              context.pagePadding,
              context.pagePadding,
              context.pagePadding,
              8,
            ),
            trailing: _LibraryCategoryDropdown(
              categories: _categoryTags,
              selectedTag: _selectedCategoryTag,
              labelBuilder: _labelForCategoryTag,
              onChanged: _setCategory,
            ),
          ),
        ),
        if (items.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text(context.l10n.libraryEmpty)),
          )
        else
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: context.pagePadding,
              vertical: 4,
            ),
            sliver: SliverList.separated(
              itemCount: items.length,
              separatorBuilder: (context, i) => const SizedBox(height: 8),
              itemBuilder: (context, i) => ContentCard(meta: items[i]),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }
}

class _LibraryCategoryDropdown extends StatelessWidget {
  final List<String> categories; // tag form: "library:xxx"
  final String? selectedTag; // null → all
  final String Function(String) labelBuilder;
  final ValueChanged<String?> onChanged;

  const _LibraryCategoryDropdown({
    required this.categories,
    required this.selectedTag,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String?>(
      value: selectedTag,
      onChanged: onChanged,
      items: [
        DropdownMenuItem<String?>(
          value: null,
          child: Text(context.l10n.libraryFilterAll),
        ),
        ...categories.map(
          (tag) => DropdownMenuItem<String?>(
            value: tag,
            child: Text(labelBuilder(tag)),
          ),
        ),
      ],
    );
  }
}
