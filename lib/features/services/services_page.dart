import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/content_service.dart';
import '../../core/markdown/markdown_renderer.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/l10n.dart';
import '../../core/services/content_localized.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<ContentService>();
    final locale = Localizations.localeOf(context);

    final future = () async {
      await svc.ensureLoaded();
      final meta = svc.findByTypeAndSlug('page', 'services');
      if (meta == null) return (null, null);
      final body = await svc.loadBodyLocalized(meta.path, locale);
      return (meta, body);
    }();

    return FutureBuilder(
      future: future,
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final (meta, body) = snap.data!;
        if (meta == null || body == null) {
          return Center(child: Text(context.l10n.notFoundGeneric));
        }
        return Padding(
          padding: EdgeInsets.all(context.pagePadding),
          child: MarkdownView(data: body),
        );
      },
    );
  }
}
