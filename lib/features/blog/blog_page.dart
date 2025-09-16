import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/state/posts_state.dart';

class BlogPage extends ConsumerWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
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
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: l10n.blogSearchTitle,
                        labelText: l10n.blogSearchTitle,
                      ),
                      onChanged: (v) => ref.read(postSearchQueryProvider.notifier).state = v,
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String?>(
                    value: selectedTag,
                    hint: Text(l10n.commonTag),
                    onChanged: (v) => ref.read(postSelectedTagProvider.notifier).state = v,
                    items: [
                      DropdownMenuItem<String?>(value: null, child: Text(l10n.commonAll)),
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
                  if (items.isEmpty) return Center(child: Text(l10n.homeNoPosts));
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
                error: (e, st) => Center(child: Text('${l10n.errLoadPosts}: $e')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        );
      },
      error: (e, st) => Center(child: Text('${l10n.errFailedToLoad}: $e')),
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.2))),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(date.toIso8601String().split('T').first, style: Theme.of(context).textTheme.bodySmall),
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
