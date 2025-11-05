import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/content_service.dart';
import '../../widgets/content_card.dart';
import '../../core/utils/responsive.dart';

import '../../core/services/auth_service.dart';

class LabsIndexPage extends StatelessWidget {
  const LabsIndexPage({super.key});
  @override
  Widget build(BuildContext context) {
    final svc = context.watch<ContentService>();
    final auth = context.watch<AuthService>();

    return FutureBuilder(
      future: svc.ensureLoaded(),
      builder: (context, snapshot) {
        final items = svc.listByType('lab', publicOnly: !auth.isLoggedIn);
        return ListView(
          padding: EdgeInsets.all(context.pagePadding),
          children: [for (final m in items) ContentCard(meta: m)],
        );
      },
    );
  }
}
