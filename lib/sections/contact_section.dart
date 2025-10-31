import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/section.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.platformDefault);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Title(
      title: 'Contact | Portfolio',
      color: theme.colorScheme.primary,
      child: SingleChildScrollView(
        child: Section(
          title: 'Contact',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: () =>
                    _launch('mailto:you@example.com?subject=Hello'),
                icon: const Icon(Icons.mail),
                label: const Text('Email'),
              ),
              OutlinedButton.icon(
                onPressed: () => _launch('https://github.com/yourname'),
                icon: const Icon(Icons.code),
                label: const Text('GitHub'),
              ),
              OutlinedButton.icon(
                onPressed: () =>
                    _launch('https://www.linkedin.com/in/yourname'),
                icon: const Icon(Icons.person),
                label: const Text('LinkedIn'),
              ),
              OutlinedButton.icon(
                onPressed: () => _launch('/assets/resume/resume.pdf'),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Resume'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
