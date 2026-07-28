import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/l10n.dart';
import '../../core/utils/responsive.dart';
import '../../widgets/section_header.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  static const _email = 'hello@desmondliew.dev';
  static const _calendlyUrl = 'https://calendly.com/desmondliew/intro';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 900;
    final padding = EdgeInsets.fromLTRB(
      context.pagePadding,
      16,
      context.pagePadding,
      32,
    );

    return SingleChildScrollView(
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: context.l10n.navContact,
              subtitle: context.l10n.contactSectionSubtitle,
              center: false,
            ),
            const SizedBox(height: 16),
            const _IntroText(),
            const SizedBox(height: 20),
            const _PrimaryContactCard(),
            const SizedBox(height: 24),
            if (isWide)
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _LeftColumn()),
                  SizedBox(width: 24),
                  Expanded(child: _RightColumn()),
                ],
              )
            else
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_LeftColumn(), SizedBox(height: 24), _RightColumn()],
              ),
          ],
        ),
      ),
    );
  }
}

class _IntroText extends StatelessWidget {
  const _IntroText();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: Text(context.l10n.contactIntro, style: textTheme.bodyMedium),
    );
  }
}

class _PrimaryContactCard extends StatelessWidget {
  const _PrimaryContactCard();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.contactPrimaryTitle,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.contactPrimaryDescription,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () => _launchUrl('mailto:${ContactPage._email}'),
                  icon: const Icon(Icons.mail_outline),
                  label: Text(context.l10n.contactPrimaryButtonEmail),
                ),
                OutlinedButton.icon(
                  onPressed: () => _launchUrl(ContactPage._calendlyUrl),
                  icon: const Icon(Icons.schedule_outlined),
                  label: Text(context.l10n.contactPrimaryButtonCall),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              context.l10n.contactPrimaryLanguages,
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _LeftColumn extends StatelessWidget {
  const _LeftColumn();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoCard(
          icon: Icons.access_time,
          title: l10n.contactOfficeHoursLabel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.contactOfficeHoursValue, style: textTheme.bodyMedium),
              const SizedBox(height: 6),
              Text(
                l10n.contactTimezoneLabel,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(l10n.contactTimezoneValue, style: textTheme.bodySmall),
              const SizedBox(height: 6),
              Text(
                l10n.contactResponseTime,
                style: textTheme.bodySmall?.copyWith(color: scheme.secondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _InfoCard(
          icon: Icons.privacy_tip_outlined,
          title: l10n.contactPrivacyTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.contactPrivacyNote, style: textTheme.bodySmall),
              const SizedBox(height: 6),
              Text(l10n.contactPrivacyWarning, style: textTheme.bodySmall),
              const SizedBox(height: 6),
              Text(
                l10n.contactPrivacyEthics,
                style: textTheme.bodySmall?.copyWith(color: scheme.secondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RightColumn extends StatelessWidget {
  const _RightColumn();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoCard(
          icon: Icons.reviews_outlined,
          title: l10n.testimonialsSectionTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.testimonialsSectionSubtitle,
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.contactTestimonialDescription,
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => context.push('/pages/testimonial'),
                icon: const Icon(Icons.open_in_new),
                label: Text(l10n.contactTestimonialButton),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _InfoCard(
          icon: Icons.accessibility_new_outlined,
          title: l10n.contactAccessibilityTitle,
          child: Text(
            l10n.contactAccessibilityNote,
            style: textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: scheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

Future<void> _launchUrl(String raw) async {
  final uri = Uri.parse(raw);
  final ok = await launchUrl(uri, mode: LaunchMode.platformDefault);
  if (!ok) {
    // optionally handle failure (e.g. SnackBar or log)
  }
}
