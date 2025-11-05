import '../models/content_meta.dart';

class SearchService {
  final List<ContentMeta> source;
  SearchService(this.source);

  List<ContentMeta> search(String q) {
    final s = q.trim().toLowerCase();
    if (s.isEmpty) return source;
    return source
        .where(
          (m) =>
              m.title.toLowerCase().contains(s) ||
              m.summary.toLowerCase().contains(s) ||
              m.tags.any((t) => t.toLowerCase().contains(s)),
        )
        .toList();
  }
}
