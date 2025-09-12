import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/state/posts_state.dart';

class BlogPage extends ConsumerWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final allAsync = ref.watch(postsProvider(localeCode));
    final filteredAsync = ref.watch(filteredPostsProvider(localeCode));
    final selectedTag = ref.watch(postSelectedTagProvider);

    return allAsync.when(
      data: (all) {
        final tags = all.expand((p) => p.tags).toSet().toList()..sort();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search title'),
                      onChanged: (v) => ref.read(postSearchQueryProvider.notifier).state = v,
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String?>(
                    value: selectedTag,
                    hint: const Text('Tag'),
                    onChanged: (v) => ref.read(postSelectedTagProvider.notifier).state = v,
                    items: [
                      const DropdownMenuItem<String?>(value: null, child: Text('All')),
                      ...tags.map((t) => DropdownMenuItem<String?>(value: t, child: Text(t))),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: filteredAsync.when(
                data: (items) {
                  if (items.isEmpty) return const Center(child: Text('No posts'));
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final crossAxisCount = width >= 1100 ? 3 : width >= 720 ? 2 : 1;
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.6,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, i) {
                          final p = items[i];
                          return _PostCard(localeCode: localeCode, id: p.id, title: p.title, date: p.date, tags: p.tags, bodyPath: p.body);
                        },
                      );
                    },
                  );
                },
                error: (e, st) => Center(child: Text('Failed to load posts: $e')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        );
      },
      error: (e, st) => Center(child: Text('Failed to load: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _PostCard extends ConsumerWidget {
  const _PostCard({
    required this.localeCode,
    required this.id,
    required this.title,
    required this.date,
    required this.tags,
    required this.bodyPath,
  });
  final String localeCode;
  final String id;
  final String title;
  final DateTime date;
  final List<String> tags;
  final String bodyPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final excerptAsync = ref.watch(postExcerptProvider((localeCode: localeCode, path: bodyPath)));
    return InkWell(
      onTap: () => context.go('/blog/$id'),
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.2))),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text('${date.toIso8601String().split('T').first}', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 10),
              Expanded(
                child: excerptAsync.when(
                  data: (ex) => Text(ex, maxLines: 4, overflow: TextOverflow.ellipsis),
                  error: (e, st) => const Text('...'),
                  loading: () => const Text('...'),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(spacing: 6, runSpacing: 6, children: tags.map((t) => Chip(label: Text(t), visualDensity: VisualDensity.compact)).toList()),
            ],
          ),
        ),
      ),
    );
  }
}
