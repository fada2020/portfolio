import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/state/search_state.dart';

class SearchWidget extends ConsumerStatefulWidget {
  const SearchWidget({
    super.key,
    this.onSearchChanged,
    this.showResults = true,
    this.autoFocus = false,
  });

  final Function(String)? onSearchChanged;
  final bool showResults;
  final bool autoFocus;

  @override
  ConsumerState<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<SearchWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _controller.text = ref.read(searchQueryProvider);

    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _focusNode.hasFocus;
      });
    });

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
    widget.onSearchChanged?.call(query);
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
      ref.read(searchHistoryProvider.notifier).addSearch(query);
      _focusNode.unfocus();
    }
  }

  void _selectSuggestion(String suggestion) {
    _controller.text = suggestion;
    _onSearchChanged(suggestion);
    _onSearchSubmitted(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;
    final popularTags = ref.watch(popularTagsProvider(localeCode));
    final searchHistory = ref.watch(searchHistoryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search input field
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: l10n.searchHint,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      _onSearchChanged('');
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
          onChanged: _onSearchChanged,
          onSubmitted: _onSearchSubmitted,
        ),

        // Search suggestions
        if (_showSuggestions && (searchHistory.isNotEmpty || popularTags.isNotEmpty))
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recent searches
                if (searchHistory.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.history,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.searchRecentSearches,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            ref.read(searchHistoryProvider.notifier).clearHistory();
                          },
                          child: Text(l10n.searchClearHistory),
                        ),
                      ],
                    ),
                  ),
                  ...searchHistory.take(5).map((query) => ListTile(
                        leading: const Icon(Icons.history, size: 20),
                        title: Text(query),
                        dense: true,
                        onTap: () => _selectSuggestion(query),
                      )),
                  if (popularTags.isNotEmpty) const Divider(height: 1),
                ],

                // Popular tags
                if (popularTags.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.trending_up,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.searchPopularTags,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: popularTags.take(8).map((tag) => ActionChip(
                        label: Text(tag),
                        onPressed: () => _selectSuggestion(tag),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      )).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),

        // Search results
        if (widget.showResults)
          const SizedBox(height: 16),
        if (widget.showResults)
          SearchResults(localeCode: localeCode),
      ],
    );
  }
}

class SearchResults extends ConsumerWidget {
  const SearchResults({
    super.key,
    required this.localeCode,
  });

  final String localeCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final searchResults = ref.watch(searchResultsProvider(localeCode));
    final query = ref.watch(searchQueryProvider);

    if (query.isEmpty) {
      return const SizedBox.shrink();
    }

    if (searchResults.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.search_off,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.searchNoResults(query),
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.searchNoResultsHint,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results summary
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            l10n.searchResultsCount(searchResults.totalResults, query),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),

        // Projects section
        if (searchResults.projects.isNotEmpty) ...[
          Row(
            children: [
              Icon(Icons.layers, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.searchProjectsSection(searchResults.projects.length),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...searchResults.projects.map((project) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.layers),
                  title: Text(project.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(project.summary),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        children: project.stack.take(3).map((tech) => Chip(
                          label: Text(tech),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        )).toList(),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => context.go('/projects/${project.id}'),
                ),
              )),
          const SizedBox(height: 24),
        ],

        // Posts section
        if (searchResults.posts.isNotEmpty) ...[
          Row(
            children: [
              Icon(Icons.article, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.searchPostsSection(searchResults.posts.length),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...searchResults.posts.map((post) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.article),
                  title: Text(post.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.date.toLocal().toString().split(' ')[0],
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        children: post.tags.take(3).map((tag) => Chip(
                          label: Text(tag),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        )).toList(),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => context.go('/blog/${post.id}'),
                ),
              )),
        ],
      ],
    );
  }
}