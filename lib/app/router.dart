import 'package:go_router/go_router.dart';
import '../core/services/content_service.dart';
import '../features/shell/shell.dart';
import '../features/home/home_page.dart';
import '../features/pages/page_viewer.dart';
import '../features/blog/index_page.dart';
import '../features/blog/detail_page.dart';
import '../features/projects/index_page.dart';
import '../features/projects/detail_page.dart';
import '../features/labs/index_page.dart';
import '../features/labs/detail_page.dart';
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
            builder: (context, state) => const BlogIndexPage(),
          ),
          GoRoute(
            path: '/blog/:slug',
            builder: (context, state) =>
                BlogDetailPage(slug: state.pathParameters['slug']!),
          ),

          GoRoute(
            path: '/projects',
            builder: (context, state) => const ProjectsIndexPage(),
          ),
          GoRoute(
            path: '/projects/:slug',
            builder: (context, state) =>
                ProjectDetailPage(slug: state.pathParameters['slug']!),
          ),

          GoRoute(
            path: '/labs',
            builder: (context, state) => const LabsIndexPage(),
          ),
          GoRoute(
            path: '/labs/:slug',
            builder: (context, state) =>
                LabDetailPage(slug: state.pathParameters['slug']!),
          ),

          GoRoute(
            path: '/library',
            builder: (context, state) => const LibraryIndexPage(),
          ),
          GoRoute(
            path: '/library/:slug',
            builder: (context, state) =>
                LibraryDetailPage(slug: state.pathParameters['slug']!),
          ),

          GoRoute(
            path: '/meta',
            builder: (context, state) => const MetaIndexPage(),
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
