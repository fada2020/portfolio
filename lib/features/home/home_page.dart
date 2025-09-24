import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/state/posts_state.dart';
import 'package:portfolio/state/profile_state.dart';
import 'package:portfolio/state/projects_state.dart';
import 'package:portfolio/utils/period.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;
    
    final profileAsync = ref.watch(profileProvider(localeCode));
    final projectsAsync = ref.watch(projectsProvider(localeCode));
    final postsAsync = ref.watch(postsProvider(localeCode));

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Hero section
            profileAsync.when(
              data: (p) => Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Flex(
                    direction: wide ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Text('${p.title} · ${p.location}', style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 12),
                            ...p.summary.take(3).map((s) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('• '),
                                      Expanded(child: Text(s)),
                                    ],
                                  ),
                                )),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                FilledButton.icon(
                                  icon: const Icon(Icons.layers),
                                  label: Text(l10n.navProjects),
                                  onPressed: () => context.go('/projects'),
                                ),
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.forum),
                                  label: Text(l10n.commonBlog),
                                  onPressed: () => context.go('/blog'),
                                ),
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.contact_mail),
                                  label: Text(l10n.commonContact),
                                  onPressed: () => context.go('/contact'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              error: (e, st) => const _ErrorBox(message: 'Failed to load profile'),
              loading: () => const _Shimmer(height: 160),
            ),

            const SizedBox(height: 20),

            // Featured projects
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.homeFeaturedProjects, style: Theme.of(context).textTheme.titleLarge),
                TextButton(onPressed: () => context.go('/projects'), child: Text(l10n.navProjects))
              ],
            ),
            const SizedBox(height: 8),
            projectsAsync.when(
              data: (items) {
                final sorted = [...items]..sort((a, b) => periodStartKey(b.period).compareTo(periodStartKey(a.period)));
                final featured = sorted.take(3).toList();
                if (featured.isEmpty) {
                  return Text(l10n.homeNoProjects);
                }
                final cross = constraints.maxWidth >= 1100
                    ? 3
                    : constraints.maxWidth >= 760
                        ? 2
                        : 1;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: featured.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cross,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.6,
                  ),
                  itemBuilder: (context, i) {
                    final p = featured[i];
                    return _ProjectCard(
                      id: p.id,
                      title: p.title,
                      summary: p.summary,
                      tags: p.domains.isNotEmpty ? p.domains : p.stack,
                    );
                  },
                );
              },
              error: (e, st) => _ErrorBox(message: l10n.errLoadProjects),
              loading: () => const _GridSkeleton(),
            ),

            const SizedBox(height: 24),

            // Recent posts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.homeRecentPosts, style: Theme.of(context).textTheme.titleLarge),
                TextButton(onPressed: () => context.go('/blog'), child: Text(l10n.commonViewAll)),
              ],
            ),
            const SizedBox(height: 8),
            postsAsync.when(
              data: (items) {
                final sorted = [...items]..sort((a, b) => b.date.compareTo(a.date));
                final recent = sorted.take(3).toList();
                if (recent.isEmpty) return Text(l10n.homeNoPosts);
                return Column(
                  children: [
                    for (final p in recent) _PostPreviewCard(localeCode: localeCode, id: p.id, title: p.title, date: p.date, tags: p.tags, bodyPath: p.body)],
                );
              },
              error: (e, st) => _ErrorBox(message: l10n.errLoadPosts),
              loading: () => const _ListSkeleton(count: 3),
            ),
          ],
        );
      },
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.id, required this.title, required this.summary, required this.tags});
  final String id;
  final String title;
  final String summary;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/projects/$id'),
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Expanded(child: Text(summary, overflow: TextOverflow.ellipsis, maxLines: 3)),
              const SizedBox(height: 10),
              Wrap(spacing: 6, runSpacing: 6, children: tags.take(4).map((t) => Chip(label: Text(t), visualDensity: VisualDensity.compact)).toList()),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostPreviewCard extends ConsumerWidget {
  const _PostPreviewCard({
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
    final l10n = AppLocalizations.of(context)!;
    final formatter = DateFormat.yMMMd(l10n.localeName);
    final excerptAsync = ref.watch(postExcerptProvider((localeCode: localeCode, path: bodyPath)));
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: () => context.go('/blog/$id'),
        child: Card(
          elevation: 0.5,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(formatter.format(date), style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                excerptAsync.when(
                  data: (ex) => Text(ex, maxLines: 3, overflow: TextOverflow.ellipsis),
                  error: (e, st) => const Text('...'),
                  loading: () => const Text('...'),
                ),
                const SizedBox(height: 8),
                Wrap(spacing: 6, runSpacing: 6, children: tags.take(4).map((t) => Chip(label: Text(t), visualDensity: VisualDensity.compact)).toList()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Shimmer extends StatelessWidget {
  const _Shimmer({this.height = 100});
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final cross = c.maxWidth >= 1100
          ? 3
          : c.maxWidth >= 760
              ? 2
              : 1;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cross,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cross,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
        ),
        itemBuilder: (context, i) => const _Shimmer(height: 140),
      );
    });
  }
}

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton({this.count = 3});
  final int count;
  @override
  Widget build(BuildContext context) {
    return Column(children: List.generate(count, (_) => const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: _Shimmer(height: 80))));
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}
