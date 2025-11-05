bool metaIsPrivate(dynamic meta) {
  try {
    final v = (meta as dynamic).visibility;
    if (v is String && v.toLowerCase() == 'private') return true;
  } catch (_) {}

  try {
    final p = (meta as dynamic).private;
    if (p == true) return true;
  } catch (_) {}

  try {
    final tags = (meta as dynamic).tags;
    if (tags is Iterable && tags.any((e) => '$e'.toLowerCase() == 'private')) {
      return true;
    }
  } catch (_) {}

  return false;
}
