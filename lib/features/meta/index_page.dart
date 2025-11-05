import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/content_service.dart';
import '../../widgets/content_card.dart';
import '../../app/config.dart';
import '../../core/utils/responsive.dart';
import '../../core/services/auth_service.dart';

class MetaIndexPage extends StatelessWidget {
  const MetaIndexPage({super.key});
  @override
  Widget build(BuildContext context) {
    final cfg = context.read<AppConfig>();
    if (!cfg.showMeta) {
      return const Center(child: Text('Meta realm is disabled.'));
    }
    final svc = context.watch<ContentService>();
    final auth = context.watch<AuthService>();

    return FutureBuilder(
      future: svc.ensureLoaded(),
      builder: (context, snapshot) {
        final items = svc.listByType('meta', publicOnly: !auth.isLoggedIn);
        final publics = items.where((e) => e.isPublic).toList();
        return ListView(
          padding: EdgeInsets.all(context.pagePadding),
          children: [for (final m in publics) ContentCard(meta: m)],
        );
      },
    );
  }
}
