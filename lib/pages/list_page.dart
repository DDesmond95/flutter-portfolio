// lib/pages/list_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../content_index.dart';
import '../design/motion.dart';
import '../widgets/hover_card.dart';

class ListPage extends StatelessWidget {
  const ListPage({
    super.key,
    required this.title,
    required this.introAssetPath, // optional intro md on the page
    required this.items,
  });

  final String title;
  final String introAssetPath; // put projects/blog index md path
  final List<ContentItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Title(
      title: '$title | Portfolio',
      color: theme.colorScheme.primary,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 16),
                    // Keep intro minimal (read as a small paragraph)
                    FutureBuilder<String>(
                      future: DefaultAssetBundle.of(
                        context,
                      ).loadString(introAssetPath),
                      builder: (context, snap) {
                        final intro = snap.data ?? '';
                        final p = intro
                            .split('\n')
                            .where(
                              (l) =>
                                  l.trim().isNotEmpty &&
                                  !l.trim().startsWith('#'),
                            )
                            .take(3)
                            .join('\n');
                        return p.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  p,
                                  style: theme.textTheme.bodyLarge,
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                    Expanded(
                      child: AppMotion.fadeIn(
                        context,
                        duration: AppMotion.small,
                        child: ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 24),
                          itemBuilder: (context, i) {
                            final it = items[i];
                            return HoverCard(
                              key: ValueKey('list_${it.route}'),
                              child: ListTile(
                                title: Text(it.title),
                                subtitle: Text(it.route),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => context.go(it.route),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
