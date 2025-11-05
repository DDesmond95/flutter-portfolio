import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/content_service.dart';
import '../../widgets/content_card.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/l10n.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<ContentService>();
    return FutureBuilder(
      future: svc.ensureLoaded(),
      builder: (context, snap) {
        final featured = [
          ...svc.listByType('project').take(3),
          ...svc.listByType('blog').take(3),
        ];
        return ListView(
          padding: EdgeInsets.all(context.pagePadding),
          children: [
            Text(
              context.l10n.homeTagline,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            for (final m in featured) ContentCard(meta: m),
          ],
        );
      },
    );
  }
}
