// lib/content_index.dart
class ContentItem {
  final String title;
  final String path; // assets path
  final String route; // site route
  const ContentItem({
    required this.title,
    required this.path,
    required this.route,
  });
}

class ContentIndex {
  // Single pages
  static const homeHero = ContentItem(
    title: 'Home',
    path: 'content/home/hero.md',
    route: '/',
  );
  static const homeHighlights = ContentItem(
    title: 'Highlights',
    path: 'content/home/highlights.md',
    route: '/', // rendered inside Home if you want; kept for completeness
  );

  static const about = ContentItem(
    title: 'About',
    path: 'content/about/about.md',
    route: '/about',
  );
  static const workStyle = ContentItem(
    title: 'How I Work',
    path: 'content/about/work_style.md',
    route: '/about',
  );

  static const skills = ContentItem(
    title: 'Skills',
    path: 'content/skills/skills.md',
    route: '/skills',
  );
  static const tools = ContentItem(
    title: 'Tools',
    path: 'content/skills/tools.md',
    route: '/skills',
  );

  static const experience = ContentItem(
    title: 'Experience',
    path: 'content/experience/experience.md',
    route: '/experience',
  );

  static const openSource = ContentItem(
    title: 'Open Source',
    path: 'content/open_source.md',
    route: '/open-source',
  );
  static const education = ContentItem(
    title: 'Education',
    path: 'content/education.md',
    route: '/education',
  );
  static const contact = ContentItem(
    title: 'Contact',
    path: 'content/contact.md',
    route: '/contact',
  );
  static const now = ContentItem(
    title: 'Now',
    path: 'content/now.md',
    route: '/now',
  );
  static const uses = ContentItem(
    title: 'Uses',
    path: 'content/uses.md',
    route: '/uses',
  );
  static const roadmap = ContentItem(
    title: 'Roadmap',
    path: 'content/roadmap.md',
    route: '/roadmap',
  );
  static const testimonials = ContentItem(
    title: 'Testimonials',
    path: 'content/testimonials.md',
    route: '/testimonials',
  );
  static const faq = ContentItem(
    title: 'FAQ',
    path: 'content/faq.md',
    route: '/faq',
  );
  static const privacy = ContentItem(
    title: 'Privacy',
    path: 'content/privacy.md',
    route: '/privacy',
  );
  static const colophon = ContentItem(
    title: 'Colophon',
    path: 'content/colophon.md',
    route: '/colophon',
  );

  // Projects index page
  static const projectsIndex = ContentItem(
    title: 'Projects',
    path: 'content/projects/index.md',
    route: '/projects',
  );

  // Project case studies (slug -> file)
  static const projects = <ContentItem>[
    ContentItem(
      title: 'CovidTrace',
      path: 'content/projects/covidtrace.md',
      route: '/projects/covidtrace',
    ),
    ContentItem(
      title: 'Judicial V2T',
      path: 'content/projects/judicial_v2t.md',
      route: '/projects/judicial_v2t',
    ),
    ContentItem(
      title: 'AI Sketch',
      path: 'content/projects/ai_sketch.md',
      route: '/projects/ai_sketch',
    ),
    ContentItem(
      title: 'Image Classification Platform',
      path: 'content/projects/image_classification_platform.md',
      route: '/projects/image_classification_platform',
    ),
    ContentItem(
      title: 'Resume Screening AI',
      path: 'content/projects/resume_screening_ai.md',
      route: '/projects/resume_screening_ai',
    ),
    ContentItem(
      title: 'Plant Detection (Flutter + TFLite)',
      path: 'content/projects/plant_detection.md',
      route: '/projects/plant_detection',
    ),
    ContentItem(
      title: 'Orientation & Mobility Survey',
      path: 'content/projects/o&m_survey.md',
      route: '/projects/o_and_m_survey',
    ),
  ];

  // Blog index
  static const blogIndex = ContentItem(
    title: 'Blog',
    path: 'content/blog/index.md',
    route: '/blog',
  );

  // Blog posts (slug -> file)
  static const posts = <ContentItem>[
    ContentItem(
      title: 'Human-Centered AI',
      path: 'content/blog/human_centered_ai.md',
      route: '/blog/human_centered_ai',
    ),
    ContentItem(
      title: 'Whisper Fine-Tuning Lessons',
      path: 'content/blog/whisper_fine_tuning.md',
      route: '/blog/whisper_fine_tuning',
    ),
    ContentItem(
      title: 'Low-Stress Software',
      path: 'content/blog/low_stress_software.md',
      route: '/blog/low_stress_software',
    ),
    ContentItem(
      title: 'LangChain + LLM Integration',
      path: 'content/blog/langchain_integration.md',
      route: '/blog/langchain_integration',
    ),
  ];
}
