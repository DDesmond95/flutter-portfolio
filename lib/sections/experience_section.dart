import 'package:flutter/material.dart';
import '../widgets/section.dart';
import '../widgets/experience_tile.dart';
import '../data/experience.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Title(
      title: 'Experience | Portfolio',
      color: theme.colorScheme.primary,
      child: SingleChildScrollView(
        child: Section(
          title: 'Experience',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [for (final e in experiences) ExperienceTile(item: e)],
          ),
        ),
      ),
    );
  }
}
