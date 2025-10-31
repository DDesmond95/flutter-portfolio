import 'package:intl/intl.dart';

class Experience {
  final String role;
  final String company;
  final String location;
  final DateTime start;
  final DateTime? end;
  final List<String> bullets;
  final List<String> stack;

  const Experience({
    required this.role,
    required this.company,
    required this.location,
    required this.start,
    required this.end,
    required this.bullets,
    required this.stack,
  });

  String get dateRange {
    final f = DateFormat('MMM yyyy');
    final s = f.format(start);
    final e = end == null ? 'Present' : f.format(end!);
    return '$s — $e';
  }
}

final experiences = <Experience>[
  Experience(
    role: 'Flutter Developer',
    company: 'Acme Corp',
    location: 'Remote',
    start: DateTime(2023, 3, 1),
    end: null,
    bullets: [
      'Built and shipped a cross-platform app to 50k MAU with 99.9% crash-free sessions.',
      'Cut initial page load by 35% through renderer tuning and asset optimization.',
      'Led CI/CD migration to GitHub Actions with automated web deployments.',
    ],
    stack: ['Flutter', 'Dart', 'GitHub Actions', 'Firebase', 'REST'],
  ),
  Experience(
    role: 'Mobile Engineer',
    company: 'Beta Studio',
    location: 'Kuching, MY',
    start: DateTime(2021, 6, 1),
    end: DateTime(2023, 2, 1),
    bullets: [
      'Implemented responsive layouts for web and mobile from a shared codebase.',
      'Improved widget test coverage from 18% to 62% using golden tests.',
    ],
    stack: ['Flutter', 'Dart', 'Riverpod', 'Mockito'],
  ),
];
