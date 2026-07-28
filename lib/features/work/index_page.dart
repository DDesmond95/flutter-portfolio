import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/content_service.dart';
import '../../core/models/content_meta.dart';
import '../../widgets/content_card.dart';
import '../../widgets/section_header.dart';
import '../../core/utils/l10n.dart';
import '../../core/services/auth_service.dart';

enum WorkFilter { all, projects, labs, products }

class WorkIndexPage extends StatefulWidget {
  final WorkFilter initial;
  const WorkIndexPage({super.key, this.initial = WorkFilter.all});

  @override
  State<WorkIndexPage> createState() => _WorkIndexPageState();
}

class _WorkIndexPageState extends State<WorkIndexPage> {
  late WorkFilter _filter;
  bool _loading = true;
  List<ContentMeta> _items = const [];

  @override
  void initState() {
    super.initState();
    _filter = widget.initial;
    _load();
  }

  @override
  void didUpdateWidget(covariant WorkIndexPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When /work?f=... changes, GoRouter rebuilds with a new `initial`.
    // Sync the internal filter + reload items.
    if (oldWidget.initial != widget.initial) {
      _filter = widget.initial;
      _load();
    }
  }

  List<ContentMeta> _normalize(List<ContentMeta> list) {
    // 1. Dedup by slug
    final unique = <ContentMeta>[];
    final seen = <String>{};
    for (final item in list) {
      if (seen.contains(item.slug)) continue;
      seen.add(item.slug);
      unique.add(item);
    }

    // 2. Sort (Newest first)
    unique.sort((a, b) {
      return (b.date ?? DateTime(1970)).compareTo(a.date ?? DateTime(1970));
    });
    return unique;
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final svc = context.read<ContentService>();
    final auth = context.read<AuthService>();

    // 🔑 Make sure the encrypted index + contents are loaded first
    await svc.ensureLoaded();

    final locale = Localizations.localeOf(context).languageCode;

    final projects = _normalize([
      ...svc.listByType('projects', publicOnly: !auth.isLoggedIn, lang: locale),
      ...svc.listByType('project', publicOnly: !auth.isLoggedIn, lang: locale),
    ]);
    final labs = _normalize([
      ...svc.listByType('labs', publicOnly: !auth.isLoggedIn, lang: locale),
      ...svc.listByType('lab', publicOnly: !auth.isLoggedIn, lang: locale),
    ]);
    final products = _normalize([
      ...svc.listByType('products', publicOnly: !auth.isLoggedIn, lang: locale),
      ...svc.listByType('product', publicOnly: !auth.isLoggedIn, lang: locale),
    ]);
    final all = _normalize([...projects, ...labs, ...products]);

    setState(() {
      _applyFilter(
        projects: projects,
        labs: labs,
        products: products,
        all: all,
        filter: _filter,
      );
      _loading = false;
    });
  }

  void _setFilter(WorkFilter f) {
    setState(() => _filter = f);
    // URL updates ...

    final svc = context.read<ContentService>();
    final auth = context.read<AuthService>();

    final locale = Localizations.localeOf(context).languageCode;

    final projects = _normalize([
      ...svc.listByType('projects', publicOnly: !auth.isLoggedIn, lang: locale),
      ...svc.listByType('project', publicOnly: !auth.isLoggedIn, lang: locale),
    ]);
    final labs = _normalize([
      ...svc.listByType('labs', publicOnly: !auth.isLoggedIn, lang: locale),
      ...svc.listByType('lab', publicOnly: !auth.isLoggedIn, lang: locale),
    ]);
    final products = _normalize([
      ...svc.listByType('products', publicOnly: !auth.isLoggedIn, lang: locale),
      ...svc.listByType('product', publicOnly: !auth.isLoggedIn, lang: locale),
    ]);
    final all = _normalize([...projects, ...labs, ...products]);
    setState(() {
      _applyFilter(
        projects: projects,
        labs: labs,
        products: products,
        all: all,
        filter: f,
      );
    });
  }

  void _applyFilter({
    required List<ContentMeta> projects,
    required List<ContentMeta> labs,
    required List<ContentMeta> products,
    required List<ContentMeta> all,
    required WorkFilter filter,
  }) {
    _items = switch (filter) {
      WorkFilter.projects => projects,
      WorkFilter.labs => labs,
      WorkFilter.products => products,
      _ => all,
    };
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SectionHeader(
            title: context.l10n.workSectionTitle,
            subtitle: context.l10n.workSectionSubtitle,
            trailing: _FilterDropdown(
              value: _filter,
              onChanged: (v) => _setFilter(v ?? WorkFilter.all),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        if (_loading)
          const SliverFillRemaining(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
          )
        else if (_items.isEmpty)
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(child: Text(context.l10n.workEmpty)),
            ),
          )
        else
          _WorkGrid(items: _items),

        // Add bottom padding
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final WorkFilter value;
  final ValueChanged<WorkFilter?> onChanged;
  const _FilterDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<WorkFilter>(
      value: value,
      onChanged: onChanged,
      items: [
        DropdownMenuItem(
          value: WorkFilter.all,
          child: Text(context.l10n.workFilterAll),
        ),
        DropdownMenuItem(
          value: WorkFilter.projects,
          child: Text(context.l10n.workFilterProjects),
        ),
        DropdownMenuItem(
          value: WorkFilter.labs,
          child: Text(context.l10n.workFilterLabs),
        ),
        DropdownMenuItem(
          value: WorkFilter.products,
          child: Text(context.l10n.workFilterProducts),
        ),
      ],
    );
  }
}

class _WorkGrid extends StatelessWidget {
  final List<ContentMeta> items;
  const _WorkGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    // Simple adaptive grid – falls back to list on narrow screens.
    final width = MediaQuery.of(context).size.width;
    final cross = width >= 1200
        ? 3
        : width >= 800
        ? 2
        : 1;

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cross,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: width >= 1200
            ? 4.2
            : width >= 800
            ? 3.4
            : 2.7,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, i) => ContentCard(meta: items[i]),
        childCount: items.length,
      ),
    );
  }
}
