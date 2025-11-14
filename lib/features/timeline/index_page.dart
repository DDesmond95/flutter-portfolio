import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/utils/l10n.dart';

import '../../core/services/content_service.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/visibility.dart';
import '../../widgets/section_header.dart';
import '../../widgets/visibility_badge.dart';
import 'detail_page.dart';

class TimelineIndexPage extends StatefulWidget {
  const TimelineIndexPage({super.key});

  @override
  State<TimelineIndexPage> createState() => _TimelineIndexPageState();
}

class _TimelineIndexPageState extends State<TimelineIndexPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Drives the stagger-in for the list
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Map<int, List<dynamic>> _groupByYear(List<dynamic> items) {
    final map = <int, List<dynamic>>{};
    for (final m in items) {
      final d = m.date as DateTime?;
      final y = (d ?? DateTime.now()).year;
      map.putIfAbsent(y, () => []).add(m);
    }
    final sorted = Map.fromEntries(
      map.entries.toList()
        ..sort((a, b) => b.key.compareTo(a.key)), // newest year first
    );
    for (final e in sorted.entries) {
      e.value.sort((a, b) {
        final da = a.date as DateTime?;
        final db = b.date as DateTime?;
        return (db ?? DateTime(1900)).compareTo(da ?? DateTime(1900));
      });
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<ContentService>();
    final auth = context.watch<AuthService>();

    return FutureBuilder<void>(
      future: svc.ensureLoaded(),
      builder: (context, snapshot) {
        final items = svc.listByType('timeline', publicOnly: !auth.isLoggedIn);
        final grouped = _groupByYear(items);

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SectionHeader(
                title: context.l10n.navTimeline,
                subtitle: context.l10n.timelineSubtitle,
                showDivider: false,
                padding: EdgeInsets.fromLTRB(
                  context.pagePadding,
                  context.pagePadding,
                  context.pagePadding,
                  4,
                ),
              ),
            ),
            if (items.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text(context.l10n.timelineEmpty)),
              )
            else
              ...grouped.entries.expand((e) {
                final year = e.key;
                final list = e.value;
                return [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      context.pagePadding,
                      8,
                      context.pagePadding,
                      8,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        '$year',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.pagePadding,
                      vertical: 4,
                    ),
                    sliver: SliverList.separated(
                      itemCount: list.length,
                      separatorBuilder: (context, i) =>
                          const SizedBox(height: 10),
                      itemBuilder: (ctx, i) {
                        final meta = list[i];
                        final curved = CurvedAnimation(
                          parent: _controller,
                          curve: Interval(
                            (i / (list.length + 2)).clamp(0.0, 1.0),
                            1,
                            curve: Curves.easeOutCubic,
                          ),
                        );
                        return _StaggerIn(
                          animation: curved,
                          child: _TimelineCard(meta: meta),
                        );
                      },
                    ),
                  ),
                ];
              }),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        );
      },
    );
  }
}

class _StaggerIn extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  const _StaggerIn({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, w) {
        final t = animation.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 14),
            child: child,
          ),
        );
      },
    );
  }
}

class _TimelineCard extends StatelessWidget {
  final dynamic meta;
  const _TimelineCard({required this.meta});

  @override
  Widget build(BuildContext context) {
    final title = (meta.title as String?) ?? (meta.slug as String?) ?? '';
    final summary = (meta.summary as String?) ?? '';
    final d = meta.date as DateTime?;
    final dateText = d == null
        ? ''
        : DateFormat.yMMMd(
            Localizations.localeOf(context).toString(),
          ).format(d);
    final isPrivate = metaIsPrivate(meta);

    // OpenContainer gives a smooth material container transform.
    return OpenContainer(
      closedElevation: 0,
      openElevation: 0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      openShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      closedColor: Theme.of(context).colorScheme.surface,
      openColor: Theme.of(context).colorScheme.surface,
      transitionDuration: const Duration(milliseconds: 420),
      transitionType: ContainerTransitionType.fadeThrough,
      closedBuilder: (ctx, open) {
        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: open,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DatePill(text: dateText),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + Private badge
                      Row(
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
                      if (summary.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          summary,
                          maxLines: 3,
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
        );
      },
      openBuilder: (ctx, close) {
        // Inline detail experience (no route push) with the same content
        return _InlineDetail(meta: meta);
      },
    );
  }
}

class _DatePill extends StatelessWidget {
  final String text;
  const _DatePill({required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: scheme.onSecondaryContainer),
      ),
    );
  }
}

class _InlineDetail extends StatelessWidget {
  final dynamic meta;
  const _InlineDetail({required this.meta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 🔧 Remove tooltip to avoid overlay during animation
        leading: Semantics(
          label: MaterialLocalizations.of(context).backButtonTooltip,
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        title: Text(
          (meta.title as String?) ?? (meta.slug as String?) ?? '',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(child: TimelineDetailPage(slug: meta.slug as String)),
    );
  }
}
