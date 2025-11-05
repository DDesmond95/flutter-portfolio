import 'package:yaml/yaml.dart';

class FrontMatterParseResult {
  final Map<String, dynamic> meta;
  final String body;
  FrontMatterParseResult(this.meta, this.body);
}

FrontMatterParseResult parseFrontMatter(String raw) {
  if (!raw.startsWith('---')) {
    return FrontMatterParseResult({}, raw);
  }
  final delimiter = '\n---';
  final end = raw.indexOf(delimiter, 3);
  if (end == -1) return FrontMatterParseResult({}, raw);
  final header = raw.substring(3, end).trim();
  final body = raw.substring(end + delimiter.length).trimLeft();

  final YamlMap y = loadYaml(header);
  final meta = <String, dynamic>{};
  for (final k in y.keys) {
    final v = y[k];
    if (v is YamlList) {
      meta[k.toString()] = v.toList();
    } else {
      meta[k.toString()] = v;
    }
  }
  return FrontMatterParseResult(meta, body);
}
