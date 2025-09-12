import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/state/projects_state.dart';
import 'package:portfolio/state/projects_filter.dart';

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final allAsync = ref.watch(projectsProvider(localeCode));
    final filteredAsync = ref.watch(filteredProjectsProvider(localeCode));
    final filter = ref.watch(projectsFilterProvider);

    return allAsync.when(
      data: (all) {
        final stacks = all.expand((p) => p.stack).toSet().toList()..sort();
        final domains = all.expand((p) => p.domains).toSet().toList()..sort();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  const Text('Filters', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  DropdownButton<ProjectSort>(
                    value: filter.sort,
                    onChanged: (v) => v == null ? null : ref.read(projectsFilterProvider.notifier).setSort(v),
                    items: const [
                      DropdownMenuItem(value: ProjectSort.latest, child: Text('Latest')),
                      DropdownMenuItem(value: ProjectSort.title, child: Text('Title A-Z')),
                    ],
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => ref.read(projectsFilterProvider.notifier).clear(),
                    child: const Text('Clear')
                  ),
                ],
              ),
            ),
            if (stacks.isNotEmpty)
              _ChipsSection(
                label: 'Stacks',
                values: stacks,
                selected: filter.stacks,
                onToggle: (s) => ref.read(projectsFilterProvider.notifier).toggleStack(s),
              ),
            if (domains.isNotEmpty)
              _ChipsSection(
                label: 'Domains',
                values: domains,
                selected: filter.domains,
                onToggle: (d) => ref.read(projectsFilterProvider.notifier).toggleDomain(d),
              ),
            const Divider(height: 1),
            Expanded(
              child: filteredAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return const Center(child: Text('No projects match filters.'));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final p = items[i];
                      return ListTile(
                        title: Text(p.title),
                        subtitle: Text(p.summary),
                        trailing: Text((p.domains.isNotEmpty ? p.domains : p.stack).join(' · ')),
                        onTap: () => context.go('/projects/${p.id}'),
                      );
                    },
                  );
                },
                error: (e, st) => Center(child: Text('Failed to load projects: $e')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        );
      },
      error: (e, st) => Center(child: Text('Failed to load projects: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ChipsSection extends StatelessWidget {
  const _ChipsSection({required this.label, required this.values, required this.selected, required this.onToggle});
  final String label;
  final List<String> values;
  final Set<String> selected;
  final void Function(String value) onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final v in values)
                FilterChip(
                  label: Text(v),
                  selected: selected.contains(v),
                  onSelected: (_) => onToggle(v),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
