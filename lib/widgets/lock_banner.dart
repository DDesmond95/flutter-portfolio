import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LockBanner extends StatelessWidget {
  final String type;
  final String slug;
  const LockBanner({super.key, required this.type, required this.slug});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 48),
              const SizedBox(height: 12),
              Text(
                'This $type is private.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const Text('Log in with passphrase to view the content.'),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => context.go('/login'),
                icon: const Icon(Icons.lock_open),
                label: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
