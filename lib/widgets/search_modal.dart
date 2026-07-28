import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/models/content_meta.dart';
import '../core/services/search_service.dart';

/// Maximum number of search results to display
const int _maxResults = 10;

/// Maximum characters for summary preview
const int _maxSummaryChars = 100;

/// A modal dialog that provides search functionality across portfolio content.
class SearchModal extends StatefulWidget {
  /// The list of content metadata to search through
  final List<ContentMeta> content;

  const SearchModal({
    super.key,
    required this.content,
  });

  /// Displays the search modal as a dialog.
  ///
  /// Returns the selected [ContentMeta] if the user taps on a result,
  /// or null if the dialog is dismissed.
  static Future<ContentMeta?> show({
    required BuildContext context,
    required List<ContentMeta> content,
  }) {
    return showDialog<ContentMeta>(
      context: context,
      builder: (context) => SearchModal(content: content),
    );
  }

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  late final SearchService _searchService;
  final TextEditingController _queryController = TextEditingController();
  List<ContentMeta> _results = [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchService = SearchService(widget.content);
    _results = _searchService.search('');
    _queryController.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _queryController.removeListener(_onQueryChanged);
    _queryController.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    final query = _queryController.text;
    if (query == _query) return;

    setState(() {
      _query = query;
      _results = _searchService.search(query).take(_maxResults).toList();
    });
  }

  void _onResultTap(ContentMeta result) {
    Navigator.of(context).pop(result);
    _navigateToContent(result);
  }

  void _navigateToContent(ContentMeta content) {
    final path = _buildPathForContent(content);
    if (path != null) {
      context.go(path);
    }
  }

  String? _buildPathForContent(ContentMeta content) {
    final slug = content.slug;
    return switch (content.type) {
      'blog' => '/blog/$slug',
      'project' => '/projects/$slug',
      'lab' => '/labs/$slug',
      'product' => '/products/$slug',
      'library' => '/library/$slug',
      'meta' || 'philosophy' => '/meta/$slug',
      'foundation' => '/foundation/$slug',
      'people' => '/people/$slug',
      'timeline' => '/timeline/$slug',
      'page' => '/pages/$slug',
      _ => '/pages/$slug',
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
          maxHeight: 500,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearchField(colorScheme),
              const SizedBox(height: 16),
              Flexible(child: _buildResultsList(colorScheme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(ColorScheme colorScheme) {
    return TextField(
      controller: _queryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search content...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _query.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _queryController.clear(),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
      ),
    );
  }

  Widget _buildResultsList(ColorScheme colorScheme) {
    // Empty state: no query entered
    if (_query.isEmpty) {
      return _buildEmptyState(colorScheme);
    }

    // No results state
    if (_results.isEmpty) {
      return _buildNoResultsState(colorScheme);
    }

    // Results list
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final item = _results[index];
        return _SearchResultTile(
          content: item,
          query: _query,
          onTap: () => _onResultTap(item),
        );
      },
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 48,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Search your portfolio',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find pages, projects, blog posts, and more',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// A single search result tile showing title, summary preview, and type badge.
class _SearchResultTile extends StatelessWidget {
  final ContentMeta content;
  final String query;
  final VoidCallback onTap;

  const _SearchResultTile({
    required this.content,
    required this.query,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      content.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _TypeBadge(type: content.type),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _truncateSummary(content.summary),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _truncateSummary(String summary) {
    if (summary.length <= _maxSummaryChars) return summary;
    return '${summary.substring(0, _maxSummaryChars)}...';
  }
}

/// A badge displaying the content type with appropriate styling.
class _TypeBadge extends StatelessWidget {
  final String type;

  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (label, color) = _getTypeInfo(type, colorScheme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (String, Color) _getTypeInfo(String type, ColorScheme colorScheme) {
    return switch (type) {
      'blog' => ('Blog', colorScheme.primary),
      'project' => ('Project', colorScheme.tertiary),
      'lab' => ('Lab', colorScheme.secondary),
      'product' => ('Product', Colors.orange),
      'library' => ('Library', Colors.teal),
      'meta' || 'philosophy' => ('Philosophy', Colors.indigo),
      'foundation' => ('Foundation', Colors.brown),
      'people' => ('People', Colors.pink),
      'timeline' => ('Timeline', Colors.amber),
      'page' => ('Page', Colors.grey),
      _ => (type, Colors.grey),
    };
  }
}

/// Helper function to display the search modal.
///
/// This is a convenience wrapper around [SearchModal.show].
Future<ContentMeta?> showSearchModal({
  required BuildContext context,
  required List<ContentMeta> content,
}) {
  return SearchModal.show(context: context, content: content);
}