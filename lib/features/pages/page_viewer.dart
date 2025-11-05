import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/content_service.dart';
import '../../core/markdown/markdown_renderer.dart';
import '../../core/utils/responsive.dart';
import '../../widgets/detail_header.dart';

class PageViewer extends StatelessWidget {
  final String slug;
  const PageViewer({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<ContentService>();
    return FutureBuilder(
      future: svc.ensureLoaded(),
      builder: (context, snap) {
        final meta = svc.findByTypeAndSlug('page', slug);
        if (meta == null) return const Center(child: Text('Page not found'));
        return FutureBuilder(
          future: svc.loadBodyByPath(meta.path),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
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
