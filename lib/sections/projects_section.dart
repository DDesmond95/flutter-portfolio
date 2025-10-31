import 'package:flutter/material.dart';
import '../widgets/section.dart';
import '../widgets/project_card.dart';
import '../data/projects.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bp = ResponsiveBreakpoints.of(context);

    // Decide layout from breakpoints
    final crossAxisCount = bp.largerThan(MOBILE) ? 2 : 1;
    final isWide = bp.largerThan(TABLET); // for aspect ratio only

    return Title(
      title: 'Projects | Portfolio',
      color: theme.colorScheme.primary,
      child: SingleChildScrollView(
        child: Section(
          title: 'Projects',
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: projects.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isWide ? 1.6 : 1.1,
            ),
            itemBuilder: (context, i) {
              final p = projects[i];
              return ProjectCard(
                title: p.title,
                description: p.description,
                tags: p.tags,
                repoUrl: p.repoUrl,
                liveUrl: p.liveUrl,
                imageAsset: p.imageAsset,
              );
            },
          ),
        ),
      ),
    );
  }
}
