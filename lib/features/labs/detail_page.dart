import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/content_service.dart';
import '../../core/markdown/markdown_renderer.dart';
import '../../core/utils/responsive.dart';
import '../../widgets/detail_header.dart';
import '../../core/utils/l10n.dart';
import '../../core/services/content_localized.dart';

class LabDetailPage extends StatelessWidget {
  final String slug;
  const LabDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<ContentService>();
    return FutureBuilder(
      future: svc.ensureLoaded(),
      builder: (context, snap) {
        final meta = svc.findByTypeAndSlug('lab', slug);
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
            return SingleChildScrollView(
              padding: EdgeInsets.all(context.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailHeader(meta: meta),
                  MarkdownView(data: snap.data!),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
