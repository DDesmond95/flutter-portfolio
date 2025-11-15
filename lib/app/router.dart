import 'package:go_router/go_router.dart';
import '../core/services/content_service.dart';
import '../features/shell/shell.dart';
import '../features/home/home_page.dart';
import '../features/pages/page_viewer.dart';
import '../features/blog/index_page.dart';
import '../features/blog/detail_page.dart';
import '../features/projects/detail_page.dart' as projects_detail;
import '../features/labs/detail_page.dart' as labs_detail;
import '../features/library/index_page.dart';
import '../features/library/detail_page.dart';
import '../features/meta/index_page.dart';
import '../features/meta/detail_page.dart';
import '../features/foundation/index_page.dart';
import '../features/foundation/detail_page.dart';
import '../features/services/services_page.dart';
import '../features/contact/contact_page.dart';
import '../features/resume/resume_page.dart';
import '../features/auth/login_page.dart';
import '../features/not_found/not_found_page.dart';
import '../features/work/index_page.dart';
import '../features/timeline/index_page.dart';
import '../features/timeline/detail_page.dart';
import '../features/people/index_page.dart';
import '../features/people/detail_page.dart';
import '../features/products/index_page.dart';
import '../features/products/detail_page.dart';

GoRouter buildRouter(ContentService content) {
  return GoRouter(
    initialLocation: '/',
    routes: [
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

          GoRoute(
            path: '/blog',
            builder: (context, state) {
              final f = state.uri.queryParameters['cat'];
              return BlogIndexPage(initialFilter: f);
            },
          ),

          GoRoute(
            path: '/blog/:slug',
            builder: (context, state) =>
                BlogDetailPage(slug: state.pathParameters['slug']!),
          ),

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
          ),
          GoRoute(
            path: '/projects/:slug',
            name: 'projectDetail',
            builder: (context, state) => projects_detail.ProjectDetailPage(
              slug: state.pathParameters['slug']!,
            ),
          ),

          GoRoute(path: '/labs', redirect: (context, state) => '/work?f=labs'),
          GoRoute(
            path: '/labs/:slug',
            name: 'labDetail',
            builder: (context, state) =>
                labs_detail.LabDetailPage(slug: state.pathParameters['slug']!),
          ),

          GoRoute(
            path: '/products',
            name: 'products-index',
            builder: (context, state) => const ProductsIndexPage(),
            routes: [
              GoRoute(
                path: ':slug',
                name: 'product-detail',
                builder: (context, state) =>
                    ProductDetailPage(slug: state.pathParameters['slug']!),
              ),
            ],
          ),

          GoRoute(
            path: '/library',
            builder: (context, state) {
              final f = state.uri.queryParameters['cat'];
              return LibraryIndexPage(initialFilter: f);
            },
          ),

          GoRoute(
            path: '/library/:slug',
            builder: (context, state) =>
                LibraryDetailPage(slug: state.pathParameters['slug']!),
          ),

          GoRoute(
            path: '/meta',
            builder: (context, state) {
              final f = state.uri.queryParameters['f'];
              return MetaIndexPage(initialCategory: f);
            },
          ),

          GoRoute(
            path: '/meta/:slug',
            builder: (context, state) =>
                MetaDetailPage(slug: state.pathParameters['slug']!),
          ),

          GoRoute(
            path: '/foundation',
            builder: (context, state) => const FoundationIndexPage(),
          ),
          GoRoute(
            path: '/foundation/:slug',
            builder: (context, state) =>
                FoundationDetailPage(slug: state.pathParameters['slug']!),
          ),

          // Timeline routes must be declared before the generic pages route
          GoRoute(
            path: '/timeline',
            builder: (context, state) => const TimelineIndexPage(),
          ),
          GoRoute(
            path: '/timeline/:slug',
            builder: (context, state) =>
                TimelineDetailPage(slug: state.pathParameters['slug']!),
          ),

          GoRoute(
            path: '/people',
            builder: (context, state) {
              final f = state.uri.queryParameters['cat'];
              return PeopleIndexPage(initialFilter: f);
            },
          ),

          GoRoute(
            path: '/people/:slug',
            builder: (context, state) =>
                PersonDetailPage(slug: state.pathParameters['slug']!),
          ),

          // Generic “page” content if you add more slugs later
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
      await content.ensureLoaded();
      return null;
    },
  );
}
