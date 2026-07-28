import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/models/content_meta.dart';
import '../../core/services/content_service.dart';
import '../../core/utils/l10n.dart';
import '../../core/utils/responsive.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<ContentService>();

    // Ensure content is loaded
    if (!svc.isLoaded) {
      return FutureBuilder(
        future: svc.ensureLoaded(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return const _HomeBody();
        },
      );
    }

    return const _HomeBody();
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    // Using a SingleChildScrollView for the whole page
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.pagePadding,
            vertical: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _HeroSection(),
              const SizedBox(height: 60),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 800),
                child: const _BentoGridSection(),
              ),
              const SizedBox(height: 80),
              const _FooterSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInDown(
          duration: const Duration(milliseconds: 800),
          child: Text(
            context.l10n.appTitle, // "Desmond Liew" or similar
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
              height: 1.1,
              fontSize: isDesktop ? 64 : 42,
            ),
          ),
        ),
        const SizedBox(height: 16),
        FadeInDown(
          delay: const Duration(milliseconds: 100),
          duration: const Duration(milliseconds: 800),
          child: Text(
            context.l10n.homeTagline,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 32),
        FadeInDown(
          delay: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 800),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _HeroButton(
                label: context.l10n.navWork,
                icon: Icons.arrow_outward,
                onTap: () => context.go('/work'),
                filled: true,
              ),
              _HeroButton(
                label: context.l10n.navContact,
                icon: Icons.mail_outline,
                onTap: () => context.go('/contact'),
                filled: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _HeroButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = filled ? theme.colorScheme.primary : theme.colorScheme.onSurface;
    final bg = filled ? theme.colorScheme.primaryContainer : Colors.transparent;
    final border = filled ? Colors.transparent : theme.colorScheme.outline;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: filled ? theme.colorScheme.onPrimaryContainer : color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              size: 18,
              color: filled ? theme.colorScheme.onPrimaryContainer : color,
            ),
          ],
        ),
      ),
    );
  }
}

class _BentoGridSection extends StatelessWidget {
  const _BentoGridSection();

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<ContentService>();
    final locale = Localizations.localeOf(context).languageCode;
    final width = MediaQuery.of(context).size.width;

    // Fetch Content
    final projects = svc.listByType('projects', lang: locale);
    final blogs = svc.listByType('blog', lang: locale);
    final labs = svc.listByType('labs', lang: locale);
    final meta = svc.listByType('meta', lang: locale);

    // Prepare Items
    final ContentMeta? featuredProject = projects.isNotEmpty ? projects.first : null;
    final ContentMeta? latestBlog = blogs.isNotEmpty ? blogs.first : null;
    final ContentMeta? latestLab = labs.isNotEmpty ? labs.first : null;
    final ContentMeta? philosophy = meta.isNotEmpty ? meta.first : null;

    if (width < 800) {
      // Mobile / Tablet Vertical Layout
      return Column(
        children: [
          if (featuredProject != null) _BentoCard(meta: featuredProject, isLarge: true),
          const SizedBox(height: 16),
          if (latestBlog != null) _BentoCard(meta: latestBlog),
          const SizedBox(height: 16),
          Row(
            children: [
              if (latestLab != null) Expanded(child: _BentoCard(meta: latestLab, height: 180)),
              if (latestLab != null && philosophy != null) const SizedBox(width: 16),
              if (philosophy != null) Expanded(child: _BentoCard(meta: philosophy, height: 180)),
            ],
          ),
          const SizedBox(height: 16),
          const _TechStackCard(),
        ],
      );
    }

    // Desktop Bento Grid
    // Row 1: [ Project (2/3) ] [ Blog (1/3) ]
    // Row 2: [ Lab (1/3) ] [ Tech Stack (1/3) ] [ Philosophy (1/3) ]

    return Column(
      children: [
        SizedBox(
          height: 320,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (featuredProject != null)
                Expanded(flex: 2, child: _BentoCard(meta: featuredProject, isLarge: true)),
              if (featuredProject != null && latestBlog != null)
                const SizedBox(width: 20),
              if (latestBlog != null)
                Expanded(flex: 1, child: _BentoCard(meta: latestBlog)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (latestLab != null)
                Expanded(child: _BentoCard(meta: latestLab)),
              const SizedBox(width: 20),
              const Expanded(child: _TechStackCard()),
              if (philosophy != null) ...[
                const SizedBox(width: 20),
                Expanded(child: _BentoCard(meta: philosophy)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _BentoCard extends StatefulWidget {
  final ContentMeta meta;
  final bool isLarge;
  final double? height;

  const _BentoCard({
    required this.meta,
    this.isLarge = false,
    this.height,
  });

  @override
  State<_BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<_BentoCard> {
  bool _hover = false;

  ImageProvider? _getBgImage(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return NetworkImage(path);
    return AssetImage(path);
  }

  // Generate a consistent, unique gradient for items without images
  LinearGradient _generateGradient(String slug, Color primary) {
    final hash = slug.hashCode;
    final c1 = primary;
    // Generate a secondary color based on slug hash
    final r = (hash & 0xFF0000) >> 16;
    final g = (hash & 0x00FF00) >> 8;
    final b = (hash & 0x0000FF);
    final c2 = Color.fromARGB(255, r, g, b).withValues(alpha: 0.6); // Mute it slightly

    // Direction based on hash parity
    final begin = (hash % 2 == 0) ? Alignment.topLeft : Alignment.bottomLeft;
    final end = (hash % 2 == 0) ? Alignment.bottomRight : Alignment.topRight;

    return LinearGradient(
      colors: [c1.withValues(alpha: 0.8), c2],
      begin: begin,
      end: end,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final meta = widget.meta;
    final bgImage = _getBgImage(meta.thumbnail);
    final hasImage = bgImage != null;

    // IMPORTANT: Treat "Generative Gradient" mode visually same as "Image" mode
    // i.e. White text, shadows, etc. to maintain the "Rich" aesthetic.
    // If no image, we show gradient.
    final useRichStyle = true; // Always use rich style now (Image OR Gradient)

    // Fallback Icon based on type
    final fallbackIcon = switch (meta.type) {
      'projects' => Icons.work_outline,
      'project' => Icons.work_outline,
      'labs' => Icons.science_outlined,
      'lab' => Icons.science_outlined,
      'blog' => Icons.article_outlined,
      _ => Icons.widgets_outlined,
    };

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (meta.type == 'projects' || meta.type == 'project') {
             context.go('/projects/${meta.slug}');
          } else if (meta.type == 'blog') {
             context.go('/blog/${meta.slug}');
          } else if (meta.type == 'micropost') {
             context.go('/timeline/${meta.slug}');
          } else if (meta.type == 'labs' || meta.type == 'lab') {
             context.go('/labs/${meta.slug}');
          } else {
             context.go('/pages/${meta.slug}');
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.height,
          transform: _hover ? Matrix4.identity().scaled(1.02) : Matrix4.identity(),
          // Clip ensures the background image/scrim respects borderRadius
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.black, // Base
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _hover ? theme.colorScheme.primary.withValues(alpha: 0.5) : Colors.white10,
              width: 1,
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: theme.shadowColor.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [],
          ),
          child: Stack(
            children: [
              // 1. Background (Image or Gradient)
              if (hasImage)
                Positioned.fill(
                  child: Image.asset(
                    meta.thumbnail!,
                    fit: BoxFit.cover,
                    opacity: const AlwaysStoppedAnimation(0.8),
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to gradient if image fails to load
                      return Container(
                        decoration: BoxDecoration(
                          gradient: _generateGradient(meta.slug, theme.colorScheme.primary),
                        ),
                      );
                    },
                  ),
                )
              else
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: _generateGradient(meta.slug, theme.colorScheme.primary),
                    ),
                  ),
                ),

              // Artistic Icon Background (Only for Gradient mode or if image fails)
              // We'll show it if !hasImage for now.
              if (!hasImage)
                Positioned(
                  right: -30,
                  bottom: -30,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: Icon(
                      fallbackIcon,
                      size: 180,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                ),

              // Scrim (Always needed for contrast on top of Image OR Gradient)
               Positioned.fill(
                 child: Container(
                   decoration: const BoxDecoration(
                     gradient: LinearGradient(
                       begin: Alignment.topCenter,
                       end: Alignment.bottomCenter,
                       colors: [Colors.transparent, Colors.black54],
                       stops: [0.5, 1.0],
                     ),
                   ),
                 ),
               ),

              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Tag
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Text(
                            meta.type.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (meta.date != null)
                          Text(
                            '${meta.date!.year}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                      ],
                    ),

                    const Spacer(),

                    // Title
                    Text(
                      meta.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: (widget.isLarge
                              ? theme.textTheme.headlineSmall
                              : theme.textTheme.titleMedium)
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [const Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black45)],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      meta.summary ?? '',
                      maxLines: widget.isLarge ? 3 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        shadows: [const Shadow(offset: Offset(0, 1), blurRadius: 2, color: Colors.black45)],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TechStackCard extends StatelessWidget {
  const _TechStackCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
           color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.code, size: 32, color: theme.colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            "Tech Stack",
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Python • Flutter • LangChain • Docker",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Divider(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
        const SizedBox(height: 24),
        Text(
          "© ${DateTime.now().year} Desmond Liew. Built with Flutter & Markdown.",
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
