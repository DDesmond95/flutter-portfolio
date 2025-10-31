// lib/widgets/nav_bar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/app_settings.dart';

class NavScaffold extends StatelessWidget {
  const NavScaffold({super.key, required this.child, required this.location});
  final Widget child;
  final String location;

  static final _items = <_NavItem>[
    _NavItem(label: 'Home', route: '/'),
    _NavItem(label: 'About', route: '/about'),
    _NavItem(label: 'Skills', route: '/skills'),
    _NavItem(label: 'Experience', route: '/experience'),
    _NavItem(label: 'Projects', route: '/projects'),
    _NavItem(label: 'Blog', route: '/blog'),
    _NavItem(label: 'Contact', route: '/contact'),
  ];

  int _selectedIndex(String loc) {
    if (loc.startsWith('/about')) return 1;
    if (loc.startsWith('/skills')) return 2;
    if (loc.startsWith('/experience')) return 3;
    if (loc.startsWith('/projects')) return 4;
    if (loc.startsWith('/blog')) return 5;
    if (loc.startsWith('/contact')) return 6;
    return 0;
  }

  void _onTap(BuildContext context, int i) => context.go(_items[i].route);

  @override
  Widget build(BuildContext context) {
    final index = _selectedIndex(location);
    return LayoutBuilder(
      builder: (context, c) {
        final isWide = c.maxWidth >= 1000;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Desmond Liew'),
            actions: [
              IconButton(
                tooltip: 'Toggle theme',
                onPressed: () {
                  final s = context.read<AppSettings>();
                  final next = s.themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : s.themeMode == ThemeMode.light
                      ? ThemeMode.system
                      : ThemeMode.dark;
                  s.setThemeMode(next);
                },
                icon: const Icon(Icons.brightness_6),
              ),
              Consumer<AppSettings>(
                builder: (context, s, _) => IconButton(
                  tooltip: s.reducedMotion ? 'Enable motion' : 'Reduce motion',
                  onPressed: () => s.setReducedMotion(!s.reducedMotion),
                  icon: Icon(
                    s.reducedMotion
                        ? Icons.motion_photos_off
                        : Icons.motion_photos_auto,
                  ),
                ),
              ),
            ],
          ),
          body: Row(
            children: [
              if (isWide)
                NavigationRail(
                  destinations: [
                    for (final item in _items)
                      NavigationRailDestination(
                        icon: const SizedBox(
                          width: 20,
                          height: 20,
                          child: Icon(Icons.radio_button_unchecked, size: 14),
                        ),
                        selectedIcon: const Icon(Icons.circle, size: 10),
                        label: Text(item.label),
                      ),
                  ],
                  selectedIndex: index,
                  onDestinationSelected: (i) => _onTap(context, i),
                  labelType: NavigationRailLabelType.all,
                ),
              Expanded(child: child),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: child,
                ),
              ),
            ],
          ),
          bottomNavigationBar: isWide
              ? null
              : NavigationBar(
                  selectedIndex: index,
                  onDestinationSelected: (i) => _onTap(context, i),
                  destinations: [
                    for (final item in _items)
                      NavigationDestination(
                        icon: const Icon(Icons.circle_outlined, size: 18),
                        label: item.label,
                      ),
                  ],
                ),
        );
      },
    );
  }
}

class _NavItem {
  final String label;
  final String route;
  const _NavItem({required this.label, required this.route});
}
