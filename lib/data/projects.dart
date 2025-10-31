class Project {
  final String title;
  final String description;
  final List<String> tags;
  final String? repoUrl;
  final String? liveUrl;
  final String? imageAsset; // e.g., assets/images/project_hero.webp

  const Project({
    required this.title,
    required this.description,
    required this.tags,
    this.repoUrl,
    this.liveUrl,
    this.imageAsset,
  });
}

const projects = <Project>[
  Project(
    title: 'Personal Portfolio',
    description:
        'Responsive Flutter web portfolio with GitHub Pages CI/CD and SPA routing.',
    tags: ['Flutter', 'Web', 'GitHub Actions', 'go_router'],
    repoUrl: 'https://github.com/yourname/portfolio',
    liveUrl: 'https://yourname.github.io/portfolio/',
    imageAsset: 'assets/images/project_portfolio.webp',
  ),
  Project(
    title: 'Weather Dash',
    description:
        'Minimal weather dashboard with caching and accessible charts.',
    tags: ['Flutter', 'REST', 'State Management'],
    repoUrl: 'https://github.com/yourname/weather-dash',
    liveUrl: null,
    imageAsset: 'assets/images/project_weather.webp',
  ),
];
