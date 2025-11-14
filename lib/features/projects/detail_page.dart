import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/content_service.dart';
import '../../core/markdown/markdown_renderer.dart';
import '../../widgets/lock_banner.dart';
import '../../widgets/detail_header.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/crypto_service.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/l10n.dart';
import '../../core/services/content_localized.dart';

class ProjectDetailPage extends StatelessWidget {
  final String slug;
  const ProjectDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<ContentService>();
    final auth = context.watch<AuthService>();
    final crypto = CryptoService();

    return FutureBuilder(
      future: svc.ensureLoaded(),
      builder: (context, snap) {
        final meta = svc.findByTypeAndSlug('project', slug);
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
            final body = snap.data!;
            if (crypto.isCiphertext(body) && (auth.passphrase == null)) {
              return LockBanner(slug: slug, type: 'project');
            }
            return FutureBuilder(
              future: crypto.isCiphertext(body) && auth.passphrase != null
                  ? crypto.decryptMarkdown(body, auth.passphrase!)
                  : Future.value(body),
              builder: (context, dec) {
                if (!dec.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SingleChildScrollView(
                  padding: EdgeInsets.all(context.pagePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailHeader(meta: meta),
                      MarkdownView(data: dec.data!),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
