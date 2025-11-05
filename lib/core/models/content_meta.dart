class ContentMeta {
  final String title;
  final String slug;
  final String
  type; // page | project | blog | lab | library | meta | foundation
  final String visibility; // public | private
  final DateTime? date;
  final String summary;
  final List<String> tags;
  final String? thumbnail;
  final String path;
  final String? readingTime;

  const ContentMeta({
    required this.title,
    required this.slug,
    required this.type,
    required this.visibility,
    required this.date,
    required this.summary,
    required this.tags,
    required this.thumbnail,
    required this.path,
    this.readingTime,
  });

  bool get isPublic => visibility.toLowerCase() == 'public';
}
