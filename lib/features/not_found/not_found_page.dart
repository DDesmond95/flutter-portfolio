import 'package:flutter/material.dart';
import '../../core/utils/l10n.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(context.l10n.notFound404));
  }
}
