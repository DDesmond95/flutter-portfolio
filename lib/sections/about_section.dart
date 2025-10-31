import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../widgets/section.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});
  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  late Future<String> _md;
  @override
  void initState() {
    super.initState();
    _md = rootBundle.loadString('assets/content/about.md');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Title(
      title: 'About | Portfolio',
      color: theme.colorScheme.primary,
      child: FutureBuilder<String>(
        future: _md,
        builder: (context, snap) => SingleChildScrollView(
          child: Section(
            title: 'About',
            child: snap.hasData
                ? MarkdownBody(data: snap.data!)
                : const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }
}
