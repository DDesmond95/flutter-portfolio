import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectCard extends StatelessWidget {
  final String title, description;
  final List<String> tags;
  final String? repoUrl, liveUrl, imageAsset;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.tags,
    this.repoUrl,
    this.liveUrl,
    this.imageAsset,
  });

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
      // You can surface a SnackBar if desired.
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: liveUrl != null ? () => _launch(liveUrl!) : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageAsset != null)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    imageAsset!,
                    fit: BoxFit.cover,
                    semanticLabel: '$title preview image',
                  ),
                ),
              const SizedBox(height: 12),
              Text(title, style: theme.textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(description),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags.map((t) => Chip(label: Text(t))).toList(),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (repoUrl != null)
                    TextButton(
                      onPressed: () => _launch(repoUrl!),
                      child: const Text('Code'),
                    ),
                  if (liveUrl != null)
                    TextButton(
                      onPressed: () => _launch(liveUrl!),
                      child: const Text('Live'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
