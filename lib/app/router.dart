import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/services/content_service.dart';
import '../core/services/auth_service.dart';
import '../features/shell/shell.dart';
import '../features/home/home_page.dart';
import '../features/pages/page_viewer.dart';
import '../features/blog/index_page.dart';
import '../features/blog/detail_page.dart';
import '../features/projects/detail_page.dart' as projects_detail;
import '../features/labs/detail_page.dart' as labs_detail;
import '../features/common/generic_index_page.dart';
import '../features/common/generic_detail_page.dart';
import '../features/services/services_page.dart';
import '../features/contact/contact_page.dart';
import '../features/resume/resume_page.dart';
import '../features/auth/login_page.dart';
import '../features/not_found/not_found_page.dart';
import '../features/work/index_page.dart';
import '../features/timeline/index_page.dart';
import '../features/timeline/detail_page.dart';
import '../features/products/detail_page.dart' as products_detail;
import '../features/splash/splash_page.dart';
import '../core/utils/l10n.dart'; // Needed for l10n strings in builders

GoRouter buildRouter(ContentService content) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => Shell(child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomePage()),
          GoRoute(
            path: '/services',
            builder: (context, state) => const ServicesPage(),
          ),
          GoRoute(
            path: '/contact',
            builder: (context, state) => const ContactPage(),
          ),
          GoRoute(
            path: '/resume',
            builder: (context, state) => const ResumePage(),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => const LoginPage(),
          ),

          // Blog Route with filtering
          GoRoute(
            path: '/blog',
            builder: (context, state) {
              final f = state.uri.queryParameters['cat'];
              return BlogIndexPage(initialFilter: f);
            },
            routes: [
              GoRoute(
                path: ':slug',
                builder: (context, state) =>
                    BlogDetailPage(slug: state.pathParameters['slug']!),
              ),
            ],
          ),

          // Work (Projects, Labs, Products) - Custom logic required
          GoRoute(
            path: '/work',
            name: 'work',
            builder: (context, state) {
              final f = switch (state.uri.queryParameters['f']) {
                'projects' => WorkFilter.projects,
                'labs' => WorkFilter.labs,
                'products' => WorkFilter.products,
                _ => WorkFilter.all,
              };
              return WorkIndexPage(initial: f);
            },
          ),
          GoRoute(
            path: '/projects',
            redirect: (context, state) => '/work?f=projects',
            routes: [
              GoRoute(
                path: ':slug',
                name: 'projectDetail',
                builder: (context, state) => projects_detail.ProjectDetailPage(
                  slug: state.pathParameters['slug']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/labs',
            redirect: (context, state) => '/work?f=labs',
            routes: [
              GoRoute(
                path: ':slug',
                name: 'labDetail',
                builder: (context, state) =>
                    labs_detail.LabDetailPage(slug: state.pathParameters['slug']!),
              ),
            ],
          ),
          GoRoute(
            path: '/products',
            redirect: (context, state) => '/work?f=products',
            routes: [
              GoRoute(
                path: ':slug',
                name: 'productDetail',
                builder: (context, state) => products_detail.ProductDetailPage(
                  slug: state.pathParameters['slug']!,
                ),
              ),
            ],
          ),

          // --- Generic Features (Consolidated) ---

          _buildSimpleRoute(
            path: '/library',
            indexBuilder: (c, s) => GenericIndexPage(
              contentType: 'library',
              title: c.l10n.navLibrary,
              subtitle: c.l10n.librarySectionSubtitle,
              filterPrefix: 'library:',
              initialFilterTag: s.uri.queryParameters['f'], // Consistent query param
              emptyMessage: c.l10n.libraryEmpty,
            ),
            detailBuilder: (c, s) => GenericDetailPage(
              slug: s.pathParameters['slug']!,
              contentType: 'library',
            ),
          ),

          _buildSimpleRoute(
            path: '/meta',
            indexBuilder: (c, s) => GenericIndexPage(
              contentType: 'meta',
              title: c.l10n.navPhilosophy,
              subtitle: c.l10n.philosophySectionSubtitle,
              filterPrefix: 'philosophy:',
              initialFilterTag: s.uri.queryParameters['f'],
              emptyMessage: c.l10n.philosophyEmpty,
            ),
            detailBuilder: (c, s) => GenericDetailPage(
              slug: s.pathParameters['slug']!,
              contentType: 'meta',
            ),
          ),

          _buildSimpleRoute(
            path: '/foundation',
            indexBuilder: (c, s) => GenericIndexPage(
              contentType: 'foundation',
              title: 'Foundation', // Or l10n
              subtitle: 'About the site and author.',
              filterPrefix: 'foundation:',
              initialFilterTag: s.uri.queryParameters['f'],
            ),
            detailBuilder: (c, s) => GenericDetailPage(
              slug: s.pathParameters['slug']!,
              contentType: 'foundation',
            ),
          ),

          _buildSimpleRoute(
            path: '/people',
            indexBuilder: (c, s) => GenericIndexPage(
              contentType: 'people',
              title: c.l10n.navPeople,
              subtitle: c.l10n.peopleSectionSubtitle,
              filterPrefix: 'people:',
              initialFilterTag: s.uri.queryParameters['f'],
              emptyMessage: c.l10n.peopleEmpty,
            ),
            detailBuilder: (c, s) => GenericDetailPage(
              slug: s.pathParameters['slug']!,
              contentType: 'people',
            ),
          ),

          // Timeline (Special Animation)
          _buildSimpleRoute(
            path: '/timeline',
            indexBuilder: (c, s) => const TimelineIndexPage(),
            detailBuilder: (c, s) => TimelineDetailPage(
              slug: s.pathParameters['slug']!,
            ),
          ),

          // Generic Page Viewer
          GoRoute(
            path: '/pages/:slug',
            builder: (context, state) =>
                PageViewer(slug: state.pathParameters['slug']!),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
    redirect: (context, state) async {
      final auth = context.read<AuthService>();
      // ⚡ REMOVED: await content.ensureLoaded();
      // This blocked the UI. Now SplashPage handles loading gracefully.

      final path = state.uri.toString();
      if (path.startsWith('/login') || path.startsWith('/splash')) return null;

      if (!auth.isLoggedIn && content.isPrivatePath(path)) {
        return '/';
      }

      return null;
    },
  );
}

/// Helper to build standard index+detail routes to reduce duplication.
GoRoute _buildSimpleRoute({
  required String path,
  required GoRouterWidgetBuilder indexBuilder,
  required GoRouterWidgetBuilder detailBuilder,
}) {
  return GoRoute(
    path: path,
    builder: indexBuilder,
    routes: [
      GoRoute(
        path: ':slug',
        builder: detailBuilder,
      ),
    ],
  );
}
