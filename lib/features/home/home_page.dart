import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/models/profile.dart';
import 'package:portfolio/state/posts_state.dart';
import 'package:portfolio/state/profile_state.dart';
import 'package:portfolio/state/projects_state.dart';
import 'package:portfolio/utils/period.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio/utils/animations.dart';

class _SkillHighlightData {
  const _SkillHighlightData(
      {required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;
}

const _skillHighlightsData = [
  _SkillHighlightData(
    icon: Icons.layers,
    title: 'Platform Engineering',
    subtitle: 'Modular architecture across Quest, SuperBuddies, YongClass.',
  ),
  _SkillHighlightData(
    icon: Icons.sync_alt,
    title: 'Migration & DX',
    subtitle: 'PHP → Spring Boot migration with automated delivery.',
  ),
  _SkillHighlightData(
    icon: Icons.devices_other,
    title: 'Full-stack UX',
    subtitle: 'Flutter WebView shell, responsive dashboards, polished UI.',
  ),
];

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
        final isWide = constraints.maxWidth >= 1024;
        final body = <Widget>[
          profileAsync.when(
            data: (profile) =>
                _HeroSection(profile: profile, isWide: isWide, l10n: l10n)
                    .fadeScale(duration: const Duration(milliseconds: 520)),
            error: (e, st) =>
                const _ErrorBox(message: 'Failed to load profile'),
            loading: () => const _Shimmer(height: 220),
          ),
          const SizedBox(height: 32),
          const _SkillHighlights().fadeSlide(
              duration: const Duration(milliseconds: 460),
              beginOffset: const Offset(0, 0.08),
              delay: const Duration(milliseconds: 120)),
          const SizedBox(height: 36),
          _SectionHeader(
            title: l10n.homeFeaturedProjects,
            action: TextButton(
              onPressed: () => context.go('/projects'),
              child: Text(l10n.commonViewAll),
            ),
          ),
          const SizedBox(height: 16),
          projectsAsync.when(
            data: (items) {
              final sorted = [...items]..sort((a, b) =>
                  periodStartKey(b.period).compareTo(periodStartKey(a.period)));
              final featured = sorted.take(3).toList();
              if (featured.isEmpty) {
                return _EmptyState(message: l10n.homeNoProjects);
              }
              final crossAxisCount = isWide
                  ? 3
                  : constraints.maxWidth >= 768
                      ? 2
                      : 1;
              final grid = GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: featured.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: isWide ? 1.5 : 1.35,
                ),
                itemBuilder: (context, index) {
                  final project = featured[index];
                  return _ProjectCard(
                    id: project.id,
                    title: project.title,
                    summary: project.summary,
                    tags: project.domains.isNotEmpty
                        ? project.domains
                        : project.stack,
                  ).fadeSlide(
                    delay: Duration(milliseconds: 120 * index),
                    duration: const Duration(milliseconds: 420),
                    beginOffset: const Offset(0, 0.08),
                  );
                },
              );
              return grid.fadeSlide(
                delay: const Duration(milliseconds: 80),
                duration: const Duration(milliseconds: 420),
                beginOffset: const Offset(0, 0.05),
              );
            },
            error: (e, st) => _ErrorBox(message: l10n.errLoadProjects),
            loading: () => const _GridSkeleton(),
          ),
          const SizedBox(height: 40),
          _SectionHeader(
            title: l10n.homeRecentPosts,
            action: TextButton(
              onPressed: () => context.go('/blog'),
              child: Text(l10n.commonViewAll),
            ),
          ),
          const SizedBox(height: 16),
          postsAsync.when(
            data: (items) {
              final sorted = [...items]
                ..sort((a, b) => b.date.compareTo(a.date));
              final recent = sorted.take(3).toList();
              if (recent.isEmpty) {
                return _EmptyState(message: l10n.homeNoPosts);
              }
              return Column(
                children: [
                  for (var i = 0; i < recent.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _PostPreviewCard(
                        localeCode: localeCode,
                        id: recent[i].id,
                        title: recent[i].title,
                        date: recent[i].date,
                        tags: recent[i].tags,
                        bodyPath: recent[i].body,
                      ).fadeSlide(
                        delay: Duration(milliseconds: 140 * i),
                        duration: const Duration(milliseconds: 380),
                        beginOffset: const Offset(0, 0.08),
                      ),
                    ),
                ],
              );
            },
            error: (e, st) => _ErrorBox(message: l10n.errLoadPosts),
            loading: () => const _ListSkeleton(count: 3),
          ),
          const SizedBox(height: 48),
        ];

        return ListView(
          padding:
              EdgeInsets.symmetric(horizontal: isWide ? 48 : 20, vertical: 32),
          children: body,
        );
      },
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection(
      {required this.profile, required this.isWide, required this.l10n});

  final Profile profile;
  final bool isWide;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.12),
            theme.colorScheme.secondary.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.25)),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: isWide ? 48 : 24, vertical: isWide ? 40 : 32),
      child: LayoutBuilder(
        builder: (context, box) {
          final showAside = box.maxWidth >= 720;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: showAside ? 6 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: theme.textTheme.displaySmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${profile.title} · ${profile.location}',
                        style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: profile.summary.take(3).map<Widget>((line) {
                        return _HeroBullet(text: line);
                      }).toList(),
                    ),
                    const SizedBox(height: 28),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        FilledButton.icon(
                          icon: const Icon(Icons.layers_outlined),
                          label: Text(l10n.navProjects),
                          onPressed: () => GoRouter.of(context).go('/projects'),
                        ),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.forum_outlined),
                          label: Text(l10n.commonBlog),
                          onPressed: () => GoRouter.of(context).go('/blog'),
                        ),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.contact_mail_outlined),
                          label: Text(l10n.commonContact),
                          onPressed: () => GoRouter.of(context).go('/contact'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (showAside) ...[
                const SizedBox(width: 32),
                Expanded(
                  flex: 4,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: RadialGradient(
                          colors: [
                            theme.colorScheme.primary.withValues(alpha: 0.22),
                            theme.colorScheme.secondary.withValues(alpha: 0.12),
                            theme.colorScheme.surface,
                          ],
                          radius: 1.1,
                          center: const Alignment(-0.3, -0.5),
                        ),
                        border: Border.all(
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.18)),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 24,
                            right: 24,
                            child: Icon(Icons.code_rounded,
                                size: 44,
                                color: theme.colorScheme.primary
                                    .withValues(alpha: 0.4)),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                _HeroBadge(label: 'Full-stack Engineer'),
                                SizedBox(height: 12),
                                _HeroBadge(
                                    label: 'Spring Boot · Flutter · AWS'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _HeroBullet extends StatelessWidget {
  const _HeroBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt_rounded, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Text(text,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Text(
          label,
          style:
              theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _SkillHighlights extends StatelessWidget {
  const _SkillHighlights();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;
        final crossAxis = isWide
            ? 3
            : constraints.maxWidth >= 600
                ? 2
                : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _skillHighlightsData.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxis,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: isWide ? 2.6 : 2.1,
          ),
          itemBuilder: (context, index) {
            final item = _skillHighlightsData[index];
            return DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2)),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.04),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(item.icon, color: theme.colorScheme.primary),
                    const SizedBox(height: 12),
                    Text(item.title,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(
                      item.subtitle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.4),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.action});

  final String title;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700)),
        action,
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.surface,
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.18)),
      ),
      child: Center(
        child: Text(
          message,
          style: theme.textTheme.bodyLarge
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard(
      {required this.id,
      required this.title,
      required this.summary,
      required this.tags});
  final String id;
  final String title;
  final String summary;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => context.go('/projects/$id'),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.12),
              theme.colorScheme.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.18)),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.06),
              offset: const Offset(0, 14),
              blurRadius: 28,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome_outlined,
                    color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              summary,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags.take(4).map((tag) {
                return Chip(
                  label: Text(tag),
                  visualDensity: VisualDensity.compact,
                  backgroundColor:
                      theme.colorScheme.surface.withValues(alpha: 0.7),
                );
              }).toList(),
            ),
          ],
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
    final excerptAsync = ref
        .watch(postExcerptProvider((localeCode: localeCode, path: bodyPath)));
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => context.go('/blog/$id'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: theme.colorScheme.surface,
          border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.article_outlined,
                    color: theme.colorScheme.secondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              formatter.format(date),
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 10),
            excerptAsync.when(
              data: (ex) => Text(
                ex,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              error: (e, st) => const Text('...'),
              loading: () => const Text('...'),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags
                  .take(4)
                  .map((tag) => Chip(
                      label: Text(tag), visualDensity: VisualDensity.compact))
                  .toList(),
            ),
          ],
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
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.4),
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
    return Column(
        children: List.generate(
            count,
            (_) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: _Shimmer(height: 80))));
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color:
          Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.error_outline,
                color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}
