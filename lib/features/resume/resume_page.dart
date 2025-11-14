import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/content_service.dart';
import '../../core/markdown/markdown_renderer.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/l10n.dart';
import '../../core/services/content_localized.dart';

class ResumePage extends StatelessWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<ContentService>();
    return FutureBuilder(
      future: svc.ensureLoaded(),
      builder: (context, snap) {
        final meta = svc.findByTypeAndSlug('page', 'resume');
        if (meta == null) {
          return Center(child: Text(context.l10n.notFoundGeneric));
        }
        return FutureBuilder(
          future: svc.loadBodyLocalized(
            meta.path,
            Localizations.localeOf(context),
          ),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: EdgeInsets.all(context.pagePadding),
              child: MarkdownView(data: snap.data!),
            );
          },
        );
      },
    );
  }
}
