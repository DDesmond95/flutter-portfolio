// lib/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'content_index.dart';
import 'pages/markdown_page.dart';
import 'pages/list_page.dart';
import 'widgets/nav_bar.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          NavScaffold(location: state.uri.toString(), child: child),
      routes: [
        // Home: we render hero.md directly as a page
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => NoTransitionPage(
            child: MarkdownPage(
              assetPath: ContentIndex.homeHero.path,
              explicitTitle: 'Home',
            ),
          ),
        ),

        // About
        GoRoute(
          path: '/about',
          pageBuilder: (context, state) => NoTransitionPage(
            child: MarkdownPage(
              assetPath: ContentIndex.about.path,
              explicitTitle: ContentIndex.about.title,
            ),
          ),
        ),

        // Skills (we’ll show skills.md; tools.md is extra content you can cross-link)
        GoRoute(
          path: '/skills',
          pageBuilder: (context, state) => NoTransitionPage(
            child: MarkdownPage(
              assetPath: ContentIndex.skills.path,
              explicitTitle: ContentIndex.skills.title,
            ),
          ),
        ),

        // Experience
        GoRoute(
          path: '/experience',
          pageBuilder: (context, state) => NoTransitionPage(
            child: MarkdownPage(
              assetPath: ContentIndex.experience.path,
              explicitTitle: ContentIndex.experience.title,
            ),
          ),
        ),

        // Projects index and detail routes
        GoRoute(
          path: '/projects',
          pageBuilder: (context, state) => NoTransitionPage(
            child: ListPage(
              title: 'Projects',
              introAssetPath: ContentIndex.projectsIndex.path,
              items: ContentIndex.projects,
            ),
          ),
          routes: [
            GoRoute(
              path: 'covidtrace',
              pageBuilder: (context, state) => NoTransitionPage(
                child: MarkdownPage(
                  assetPath: 'content/projects/covidtrace.md',
                  explicitTitle: 'CovidTrace',
                ),
              ),
            ),
            GoRoute(
              path: 'judicial_v2t',
              pageBuilder: (context, state) => NoTransitionPage(
                child: MarkdownPage(
                  assetPath: 'content/projects/judicial_v2t.md',
                  explicitTitle: 'Judicial V2T',
                ),
              ),
            ),
            GoRoute(
              path: 'ai_sketch',
              pageBuilder: (context, state) => NoTransitionPage(
                child: MarkdownPage(
                  assetPath: 'content/projects/ai_sketch.md',
                  explicitTitle: 'AI Sketch',
                ),
              ),
            ),
            GoRoute(
              path: 'image_classification_platform',
              pageBuilder: (context, state) => NoTransitionPage(
                child: MarkdownPage(
                  assetPath:
                      'content/projects/image_classification_platform.md',
                  explicitTitle: 'Image Classification Platform',
                ),
              ),
            ),
            GoRoute(
              path: 'resume_screening_ai',
              pageBuilder: (context, state) => NoTransitionPage(
                child: MarkdownPage(
                  assetPath: 'content/projects/resume_screening_ai.md',
                  explicitTitle: 'Resume Screening AI',
                ),
              ),
            ),
            GoRoute(
              path: 'plant_detection',
              pageBuilder: (context, state) => NoTransitionPage(
                child: MarkdownPage(
                  assetPath: 'content/projects/plant_detection.md',
                  explicitTitle: 'Plant Detection',
                ),
              ),
            ),
            GoRoute(
              path: 'o_and_m_survey',
              pageBuilder: (context, state) => NoTransitionPage(
                child: MarkdownPage(
                  assetPath: 'content/projects/o&m_survey.md',
                  explicitTitle: 'Orientation & Mobility Survey',
                ),
              ),
            ),
          ],
        ),

        // Blog index and posts
        GoRoute(
          path: '/blog',
          pageBuilder: (context, state) => NoTransitionPage(
            child: ListPage(
              title: 'Blog',
              introAssetPath: ContentIndex.blogIndex.path,
              items: ContentIndex.posts,
            ),
          ),
          routes: [
            GoRoute(
              path: 'human_centered_ai',
              pageBuilder: (context, state) => NoTransitionPage(
                child: MarkdownPage(
                  assetPath: 'content/blog/human_centered_ai.md',
                  explicitTitle: 'Human-Centered AI',
                ),
              ),
            ),
            GoRoute(
              path: 'whisper_fine_tuning',
              pageBuilder: (context, state) => NoTransitionPage(
                child: MarkdownPage(
                  assetPath: 'content/blog/whisper_fine_tuning.md',
                  explicitTitle: 'Whisper Fine-Tuning Lessons',
                ),
              ),
            ),
            GoRoute(
              path: 'low_stress_software',
              pageBuilder: (context, state) => NoTransitionPage(
                child: MarkdownPage(
                  assetPath: 'content/blog/low_stress_software.md',
                  explicitTitle: 'Low-Stress Software',
                ),
              ),
            ),
            GoRoute(
              path: 'langchain_integration',
              pageBuilder: (context, state) => NoTransitionPage(
                child: MarkdownPage(
                  assetPath: 'content/blog/langchain_integration.md',
                  explicitTitle: 'LangChain + LLM Integration',
                ),
              ),
            ),
          ],
        ),

        // Other single pages
        GoRoute(
          path: '/contact',
          pageBuilder: (context, state) => NoTransitionPage(
            child: MarkdownPage(
              assetPath: ContentIndex.contact.path,
              explicitTitle: ContentIndex.contact.title,
            ),
          ),
        ),
        GoRoute(
          path: '/open-source',
          pageBuilder: (context, state) => NoTransitionPage(
            child: MarkdownPage(
              assetPath: ContentIndex.openSource.path,
              explicitTitle: ContentIndex.openSource.title,
            ),
          ),
        ),
        GoRoute(
          path: '/education',
          pageBuilder: (context, state) => NoTransitionPage(
            child: MarkdownPage(
              assetPath: ContentIndex.education.path,
              explicitTitle: ContentIndex.education.title,
            ),
          ),
        ),
        GoRoute(
          path: '/now',
          pageBuilder: (context, state) => NoTransitionPage(
            child: MarkdownPage(
              assetPath: ContentIndex.now.path,
              explicitTitle: ContentIndex.now.title,
            ),
          ),
        ),
        GoRoute(
          path: '/uses',
          pageBuilder: (context, state) => NoTransitionPage(
            child: MarkdownPage(
              assetPath: ContentIndex.uses.path,
              explicitTitle: ContentIndex.uses.title,
            ),
          ),
        ),
        GoRoute(
          path: '/roadmap',
          pageBuilder: (context, state) => NoTransitionPage(
            child: MarkdownPage(
              assetPath: ContentIndex.roadmap.path,
              explicitTitle: ContentIndex.roadmap.title,
            ),
          ),
        ),
        GoRoute(
          path: '/testimonials',
          pageBuilder: (context, state) => NoTransitionPage(
            child: MarkdownPage(
              assetPath: ContentIndex.testimonials.path,
              explicitTitle: ContentIndex.testimonials.title,
            ),
          ),
        ),
        GoRoute(
          path: '/faq',
          pageBuilder: (context, state) => NoTransitionPage(
            child: MarkdownPage(
              assetPath: ContentIndex.faq.path,
              explicitTitle: ContentIndex.faq.title,
            ),
          ),
        ),
        GoRoute(
          path: '/privacy',
          pageBuilder: (context, state) => NoTransitionPage(
            child: MarkdownPage(
              assetPath: ContentIndex.privacy.path,
              explicitTitle: ContentIndex.privacy.title,
            ),
          ),
        ),
        GoRoute(
          path: '/colophon',
          pageBuilder: (context, state) => NoTransitionPage(
            child: MarkdownPage(
              assetPath: ContentIndex.colophon.path,
              explicitTitle: ContentIndex.colophon.title,
            ),
          ),
        ),
      ],
    ),
  ],
  errorPageBuilder: (context, state) => NoTransitionPage(
    child: Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Page not found.\n${state.matchedLocation}'),
        ),
      ),
    ),
  ),
);
