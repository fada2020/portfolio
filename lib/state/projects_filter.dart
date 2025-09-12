import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/state/projects_state.dart';
import 'package:portfolio/utils/period.dart';

enum ProjectSort { latest, title }

class ProjectsFilter {
  final Set<String> stacks;
  final Set<String> domains;
  final ProjectSort sort;
  const ProjectsFilter({
    this.stacks = const {},
    this.domains = const {},
    this.sort = ProjectSort.latest,
  });

  ProjectsFilter copyWith({Set<String>? stacks, Set<String>? domains, ProjectSort? sort}) =>
      ProjectsFilter(stacks: stacks ?? this.stacks, domains: domains ?? this.domains, sort: sort ?? this.sort);
}

class ProjectsFilterNotifier extends StateNotifier<ProjectsFilter> {
  ProjectsFilterNotifier() : super(const ProjectsFilter());

  void toggleStack(String s) {
    final next = Set<String>.from(state.stacks);
    next.contains(s) ? next.remove(s) : next.add(s);
    state = state.copyWith(stacks: next);
  }

  void toggleDomain(String d) {
    final next = Set<String>.from(state.domains);
    next.contains(d) ? next.remove(d) : next.add(d);
    state = state.copyWith(domains: next);
  }

  void setSort(ProjectSort sort) => state = state.copyWith(sort: sort);
  void clear() => state = const ProjectsFilter();
}

final projectsFilterProvider = StateNotifierProvider<ProjectsFilterNotifier, ProjectsFilter>((ref) {
  return ProjectsFilterNotifier();
});

final filteredProjectsProvider = FutureProvider.family<List<Project>, String>((ref, localeCode) async {
  final filter = ref.watch(projectsFilterProvider);
  final items = await ref.watch(projectsProvider(localeCode).future);
  Iterable<Project> list = items;

  if (filter.stacks.isNotEmpty) {
    list = list.where((p) => p.stack.any(filter.stacks.contains));
  }
  if (filter.domains.isNotEmpty) {
    list = list.where((p) => p.domains.any(filter.domains.contains));
  }

  final sorted = list.toList();
  switch (filter.sort) {
    case ProjectSort.latest:
      sorted.sort((a, b) => periodStartKey(b.period).compareTo(periodStartKey(a.period)));
      break;
    case ProjectSort.title:
      sorted.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      break;
  }
  return sorted;
});

