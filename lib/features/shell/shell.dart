// lib/features/shell/shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/config.dart';
import '../../app/theme_controller.dart';
import '../../app/lang_controller.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/l10n.dart';

class Shell extends StatelessWidget {
  final Widget child;
  const Shell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 1100;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: isCompact ? 0 : null,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: isCompact ? 8 : 12),
          child: InkWell(
            onTap: () => context.go('/'),
            child: Text(
              context.l10n.appTitle,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ),
        ),
        actions: isCompact
            ? null
            : [
                // Primary navigation (left → right)
                _nav(context, '/', context.l10n.navHome),

                // Work (All, Projects, Labs)
                _MenuButton(
                  label: context.l10n.navWork,
                  entries: [
                    MenuEntry(
                      value: 'all',
                      icon: Icons.view_list,
                      label: context.l10n.workFilterAll,
                    ),
                    MenuEntry(
                      value: 'projects',
                      icon: Icons.work_outline,
                      label: context.l10n.navProjects,
                    ),
                    MenuEntry(
                      value: 'labs',
                      icon: Icons.science_outlined,
                      label: context.l10n.navLabs,
                    ),
                    MenuEntry(
                      value: 'products',
                      icon: Icons.widgets_outlined,
                      label: context.l10n.workFilterProducts,
                    ),
                  ],
                  onSelected: (v) {
                    if (v == 'all') {
                      context.go('/work');
                    } else {
                      context.go('/work?f=$v');
                    }
                  },
                ),

                // Explore (Blog, Library, People)
                _MenuButton(
                  label: context.l10n.navDiscover,
                  entries: [
                    MenuEntry(
                      value: 'blog',
                      icon: Icons.article_outlined,
                      label: context.l10n.navBlog,
                    ),
                    MenuEntry(
                      value: 'library',
                      icon: Icons.menu_book_outlined,
                      label: context.l10n.navLibrary,
                    ),
                    MenuEntry(
                      value: 'people',
                      icon: Icons.people_outline,
                      label: context.l10n.navPeople,
                    ),
                  ],
                  onSelected: (v) {
                    switch (v) {
                      case 'blog':
                        context.go('/blog');
                        break;
                      case 'library':
                        context.go('/library');
                        break;
                      case 'people':
                        context.go('/people');
                        break;
                    }
                  },
                ),

                if (AppConfig.showMetaRealm)
                  _nav(context, '/meta', context.l10n.navPhilosophy),

                _nav(context, '/timeline', context.l10n.navTimeline),
                _nav(context, '/services', context.l10n.navServices),
                _nav(context, '/resume', context.l10n.navResume),
                _nav(context, '/contact', context.l10n.navContact),

                // About (About page, Foundation, Credits)
                _MenuButton(
                  label: context.l10n.navAbout,
                  entries: [
                    MenuEntry(
                      value: 'about',
                      icon: Icons.info_outline,
                      label: context.l10n.navAbout,
                    ),
                    MenuEntry(
                      value: 'foundation',
                      icon: Icons.layers_outlined,
                      label: context.l10n.navFoundation,
                    ),
                    MenuEntry(
                      value: 'credits',
                      icon: Icons.star_outline,
                      label: context.l10n.navCredits,
                    ),
                  ],
                  onSelected: (v) {
                    switch (v) {
                      case 'about':
                        context.go('/pages/about');
                        break;
                      case 'foundation':
                        context.go('/foundation');
                        break;
                      case 'credits':
                        // foundation/credits.md -> slug: credits
                        context.go('/foundation/credits');
                        break;
                    }
                  },
                ),

                const SizedBox(width: 6),
                const _LanguageButton(),
                const SizedBox(width: 4),
                const _ThemeButton(),
                const SizedBox(width: 8),

                // Auth
                auth.isLoggedIn
                    ? TextButton(
                        onPressed: () => context.read<AuthService>().logout(),
                        child: Text(context.l10n.navLogout),
                      )
                    : _nav(context, '/login', context.l10n.navLogin),
                const SizedBox(width: 8),
              ],
      ),
      drawer: isCompact
          ? _MobileDrawer(showMeta: AppConfig.showMetaRealm)
          : null,
      body: MediaQuery.withClampedTextScaling(
        minScaleFactor: 1.0,
        maxScaleFactor: 1.4,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(context.pagePadding),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _nav(BuildContext context, String path, String label) {
    final style = ButtonStyle(
      foregroundColor: WidgetStateProperty.all(
        Theme.of(context).colorScheme.onSurface,
      ),
      textStyle: WidgetStateProperty.all(
        Theme.of(context).textTheme.titleMedium,
      ),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
    );
    return TextButton(
      onPressed: () => context.go(path),
      style: style,
      child: Text(label),
    );
  }
}

class _MobileDrawer extends StatelessWidget {
  final bool showMeta;
  const _MobileDrawer({required this.showMeta});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            _tile(context, '/', context.l10n.navHome, Icons.home_outlined),

            const Divider(height: 16),

            // Work
            _header(context, context.l10n.navWork),
            _tile(
              context,
              '/work',
              context.l10n.workFilterAll,
              Icons.view_list,
            ),
            _tile(
              context,
              '/work?f=projects',
              context.l10n.navProjects,
              Icons.work_outline,
            ),
            _tile(
              context,
              '/work?f=labs',
              context.l10n.navLabs,
              Icons.science_outlined,
            ),
            _tile(
              context,
              '/work?f=products',
              context.l10n.workFilterProducts,
              Icons.widgets_outlined,
            ),

            const Divider(height: 16),

            // Explore
            _header(context, context.l10n.navDiscover),
            _tile(
              context,
              '/blog',
              context.l10n.navBlog,
              Icons.article_outlined,
            ),
            _tile(
              context,
              '/library',
              context.l10n.navLibrary,
              Icons.menu_book_outlined,
            ),
            _tile(
              context,
              '/people',
              context.l10n.navPeople,
              Icons.people_outline,
            ),
            if (showMeta)
              _tile(
                context,
                '/meta',
                context.l10n.navPhilosophy,
                Icons.account_tree_outlined,
              ),

            const Divider(height: 16),

            // Other pages
            _tile(
              context,
              '/timeline',
              context.l10n.navTimeline,
              Icons.timeline,
            ),
            _tile(
              context,
              '/services',
              context.l10n.navServices,
              Icons.handyman_outlined,
            ),
            _tile(
              context,
              '/resume',
              context.l10n.navResume,
              Icons.description_outlined,
            ),
            _tile(
              context,
              '/contact',
              context.l10n.navContact,
              Icons.mail_outline,
            ),

            const Divider(height: 16),

            // About
            _header(context, context.l10n.navAbout),
            _tile(
              context,
              '/pages/about',
              context.l10n.navAbout,
              Icons.info_outline,
            ),
            _tile(
              context,
              '/foundation',
              context.l10n.navFoundation,
              Icons.layers_outlined,
            ),
            _tile(
              context,
              '/foundation/credits',
              context.l10n.navCredits,
              Icons.star_outline,
            ),

            const Divider(height: 16),

            // Utilities
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: _LanguageButton(),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: _ThemeButton(),
            ),

            ListTile(
              leading: Icon(auth.isLoggedIn ? Icons.logout : Icons.lock_open),
              title: Text(
                auth.isLoggedIn
                    ? context.l10n.navLogout
                    : context.l10n.navLogin,
              ),
              onTap: () {
                Navigator.of(context).pop();
                if (auth.isLoggedIn) {
                  context.read<AuthService>().logout();
                } else {
                  context.go('/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  ListTile _tile(
    BuildContext context,
    String route,
    String label,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        Navigator.of(context).pop();
        context.go(route);
      },
    );
  }
}

class _ThemeButton extends StatelessWidget {
  const _ThemeButton();

  @override
  Widget build(BuildContext context) {
    final themeCtrl = context.watch<ThemeController>();
    return PopupMenuButton<String>(
      tooltip: context.l10n.menuTheme,
      icon: const Icon(Icons.palette_outlined),
      onSelected: (v) {
        if (v.startsWith('mode:')) {
          switch (v.split(':')[1]) {
            case 'system':
              themeCtrl.setMode(ThemeMode.system);
              break;
            case 'light':
              themeCtrl.setMode(ThemeMode.light);
              break;
            case 'dark':
              themeCtrl.setMode(ThemeMode.dark);
              break;
          }
        } else if (v.startsWith('palette:')) {
          final name = v.split(':')[1];
          final map = {
            'metal': AppPalette.metal,
            'earth': AppPalette.earth,
            'wood': AppPalette.wood,
            'fire': AppPalette.fire,
            'water': AppPalette.water,
            'yin': AppPalette.yin,
            'yang': AppPalette.yang,
            'abyss': AppPalette.abyss,
            'lunar': AppPalette.lunar,
            'storm': AppPalette.storm,
            'natural': AppPalette.natural,
            'minimal': AppPalette.minimal,
            'mono': AppPalette.mono,
          };
          themeCtrl.setPalette(map[name] ?? AppPalette.metal);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(enabled: false, child: Text(context.l10n.menuThemeMode)),
        PopupMenuItem(
          value: 'mode:system',
          child: Text(context.l10n.themeSystem),
        ),
        PopupMenuItem(
          value: 'mode:light',
          child: Text(context.l10n.themeLight),
        ),
        PopupMenuItem(value: 'mode:dark', child: Text(context.l10n.themeDark)),
        const PopupMenuDivider(),
        PopupMenuItem(enabled: false, child: Text(context.l10n.menuPalette)),
        PopupMenuItem(
          value: 'palette:metal',
          child: Text(context.l10n.paletteMetal),
        ),
        PopupMenuItem(
          value: 'palette:earth',
          child: Text(context.l10n.paletteEarth),
        ),
        PopupMenuItem(
          value: 'palette:wood',
          child: Text(context.l10n.paletteWood),
        ),
        PopupMenuItem(
          value: 'palette:fire',
          child: Text(context.l10n.paletteFire),
        ),
        PopupMenuItem(
          value: 'palette:water',
          child: Text(context.l10n.paletteWater),
        ),
        PopupMenuItem(
          value: 'palette:yin',
          child: Text(context.l10n.paletteYin),
        ),
        PopupMenuItem(
          value: 'palette:yang',
          child: Text(context.l10n.paletteYang),
        ),
        PopupMenuItem(
          value: 'palette:abyss',
          child: Text(context.l10n.paletteAbyss),
        ),
        PopupMenuItem(
          value: 'palette:lunar',
          child: Text(context.l10n.paletteLunar),
        ),
        PopupMenuItem(
          value: 'palette:storm',
          child: Text(context.l10n.paletteStorm),
        ),
        PopupMenuItem(
          value: 'palette:natural',
          child: Text(context.l10n.paletteNatural),
        ),
        PopupMenuItem(
          value: 'palette:minimal',
          child: Text(context.l10n.paletteMinimal),
        ),
        PopupMenuItem(
          value: 'palette:mono',
          child: Text(context.l10n.paletteMono),
        ),
      ],
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton();

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageController>();
    return PopupMenuButton<String>(
      tooltip: context.l10n.menuLanguage,
      icon: const Icon(Icons.language),
      onSelected: (v) {
        switch (v) {
          case 'system':
            lang.setLocale(null);
            break;
          case 'en':
            lang.setLocale(const Locale('en'));
            break;
          case 'zh':
            lang.setLocale(const Locale('zh'));
            break;
          case 'ms':
            lang.setLocale(const Locale('ms'));
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(enabled: false, child: Text(context.l10n.menuLanguage)),
        const PopupMenuDivider(),
        PopupMenuItem(value: 'system', child: Text(context.l10n.themeSystem)),
        const PopupMenuDivider(),
        PopupMenuItem(value: 'en', child: Text(context.l10n.langEnglish)),
        PopupMenuItem(value: 'zh', child: Text(context.l10n.langChinese)),
        PopupMenuItem(value: 'ms', child: Text(context.l10n.langMalay)),
      ],
    );
  }
}

class MenuEntry {
  final String? value;
  final IconData? icon;
  final String? label;

  const MenuEntry({
    required this.value,
    required this.icon,
    required this.label,
  });
}

class _MenuButton extends StatelessWidget {
  final String label;
  final List<MenuEntry> entries;
  final ValueChanged<String> onSelected;

  const _MenuButton({
    required this.label,
    required this.entries,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;
    final textStyle = Theme.of(context).textTheme.titleMedium;

    return PopupMenuButton<String>(
      tooltip: label,
      onSelected: onSelected,
      itemBuilder: (ctx) => entries
          .map<PopupMenuEntry<String>>(
            (e) => PopupMenuItem(
              value: e.value!,
              child: Row(
                children: [
                  Icon(e.icon, size: 18, color: color),
                  const SizedBox(width: 8),
                  Text(e.label!, style: TextStyle(color: color)),
                ],
              ),
            ),
          )
          .toList(),
      child: TextButton(
        onPressed: null,
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(
            Theme.of(context).colorScheme.onSurface,
          ),
          textStyle: WidgetStateProperty.all(textStyle),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
        ),
        child: Text(label),
      ),
    );
  }
}
