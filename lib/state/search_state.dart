import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/post.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/state/posts_state.dart';
import 'package:portfolio/state/projects_state.dart';

// Search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

// Search results for projects
final searchProjectsProvider = Provider.family<List<Project>, String>((ref, localeCode) {
  final query = ref.watch(searchQueryProvider);
  final projectsAsync = ref.watch(projectsProvider(localeCode));

  return projectsAsync.when(
    data: (projects) {
      if (query.isEmpty) return projects;

      final lowercaseQuery = query.toLowerCase();
      return projects.where((project) {
        // Search in title, summary, stack, domains, and role
        return project.title.toLowerCase().contains(lowercaseQuery) ||
               project.summary.toLowerCase().contains(lowercaseQuery) ||
               project.stack.any((tech) => tech.toLowerCase().contains(lowercaseQuery)) ||
               project.domains.any((domain) => domain.toLowerCase().contains(lowercaseQuery)) ||
               project.role.toLowerCase().contains(lowercaseQuery);
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Search results for posts
final searchPostsProvider = Provider.family<List<PostMeta>, String>((ref, localeCode) {
  final query = ref.watch(searchQueryProvider);
  final postsAsync = ref.watch(postsProvider(localeCode));

  return postsAsync.when(
    data: (posts) {
      if (query.isEmpty) return posts;

      final lowercaseQuery = query.toLowerCase();
      return posts.where((post) {
        // Search in title and tags
        return post.title.toLowerCase().contains(lowercaseQuery) ||
               post.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Combined search results
class SearchResults {
  final List<Project> projects;
  final List<PostMeta> posts;
  final String query;

  SearchResults({
    required this.projects,
    required this.posts,
    required this.query,
  });

  bool get isEmpty => projects.isEmpty && posts.isEmpty;
  int get totalResults => projects.length + posts.length;
}

final searchResultsProvider = Provider.family<SearchResults, String>((ref, localeCode) {
  final query = ref.watch(searchQueryProvider);
  final projects = ref.watch(searchProjectsProvider(localeCode));
  final posts = ref.watch(searchPostsProvider(localeCode));

  return SearchResults(
    projects: projects,
    posts: posts,
    query: query,
  );
});

// Popular search tags
final popularTagsProvider = Provider.family<List<String>, String>((ref, localeCode) {
  final projectsAsync = ref.watch(projectsProvider(localeCode));
  final postsAsync = ref.watch(postsProvider(localeCode));

  return projectsAsync.when(
    data: (projects) => postsAsync.when(
      data: (posts) {
        final tagCounts = <String, int>{};

        // Count tags from projects (using stack and domains)
        for (final project in projects) {
          for (final tech in project.stack) {
            tagCounts[tech] = (tagCounts[tech] ?? 0) + 1;
          }
          for (final domain in project.domains) {
            tagCounts[domain] = (tagCounts[domain] ?? 0) + 1;
          }
        }

        // Count tags from posts
        for (final post in posts) {
          for (final tag in post.tags) {
            tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
          }
        }

        // Sort by frequency and return top 10
        final sortedTags = tagCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return sortedTags.take(10).map((e) => e.key).toList();
      },
      loading: () => <String>[],
      error: (_, __) => <String>[],
    ),
    loading: () => <String>[],
    error: (_, __) => <String>[],
  );
});

// Search history (for future enhancement)
class SearchHistory {
  static const int maxHistoryItems = 10;

  final List<String> _history = [];

  List<String> get history => List.unmodifiable(_history);

  void addSearch(String query) {
    if (query.trim().isEmpty) return;

    _history.remove(query); // Remove if exists
    _history.insert(0, query); // Add to front

    if (_history.length > maxHistoryItems) {
      _history.removeRange(maxHistoryItems, _history.length);
    }
  }

  void clearHistory() {
    _history.clear();
  }
}

final searchHistoryProvider = StateNotifierProvider<SearchHistoryNotifier, List<String>>((ref) {
  return SearchHistoryNotifier();
});

class SearchHistoryNotifier extends StateNotifier<List<String>> {
  SearchHistoryNotifier() : super([]);

  void addSearch(String query) {
    if (query.trim().isEmpty) return;

    final newState = [...state];
    newState.remove(query); // Remove if exists
    newState.insert(0, query); // Add to front

    if (newState.length > SearchHistory.maxHistoryItems) {
      newState.removeRange(SearchHistory.maxHistoryItems, newState.length);
    }

    state = newState;
  }

  void clearHistory() {
    state = [];
  }
}