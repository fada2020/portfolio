import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/state/projects_filter.dart';
import 'package:portfolio/state/projects_state.dart';

void main() {
  test('filteredProjectsProvider filters by stack and domain and sorts latest', () async {
    final data = <Project>[
      const Project(
        id: 'a',
        title: 'Older Billing',
        period: '2022.01–2022.06',
        stack: ['Java', 'Flink'],
        domains: ['Billing'],
        role: 'BE',
        summary: 'older',
      ),
      const Project(
        id: 'b',
        title: 'New Gateway',
        period: '2024.02–',
        stack: ['Kotlin', 'Spring Boot'],
        domains: ['Gateway'],
        role: 'BE',
        summary: 'newer',
      ),
    ];

    final container = ProviderContainer(overrides: [
      projectsProvider.overrideWithProvider((locale) => FutureProvider<List<Project>>((ref) async => data)),
    ]);

    // Initially, no filters; should return both sorted by latest first
    final initial = await container.read(filteredProjectsProvider('en').future);
    expect(initial.map((p) => p.id).toList(), ['b', 'a']);

    // Filter by stack 'Kotlin' yields only 'b'
    container.read(projectsFilterProvider.notifier).toggleStack('Kotlin');
    final byStack = await container.read(filteredProjectsProvider('en').future);
    expect(byStack.map((p) => p.id).toList(), ['b']);

    // Switch to domain 'Billing' -> empty because stack filter still active
    container.read(projectsFilterProvider.notifier).toggleDomain('Billing');
    final bothFilters = await container.read(filteredProjectsProvider('en').future);
    expect(bothFilters, isEmpty);

    // Clear -> domain only
    container.read(projectsFilterProvider.notifier).clear();
    container.read(projectsFilterProvider.notifier).toggleDomain('Billing');
    final byDomain = await container.read(filteredProjectsProvider('en').future);
    expect(byDomain.map((p) => p.id).toList(), ['a']);
  });
}
