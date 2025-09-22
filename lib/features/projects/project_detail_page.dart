import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/state/projects_state.dart';
import 'package:portfolio/utils/syntax_highlighter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectDetailPage extends ConsumerWidget {
  const ProjectDetailPage({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(projectByIdProvider((localeCode: localeCode, id: id)));
    return async.when(
      data: (p) {
        if (p == null) return Center(child: Text(l10n.projectNotFound));
        final bodyAsync = ref.watch(projectBodyProvider((localeCode: localeCode, path: p.body)));
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Text(p.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 6),
              Text('${p.period} · ${p.role}', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: [
                ...p.domains.map((d) => Chip(label: Text(d))),
                ...p.stack.map((s) => Chip(label: Text(s))),
              ]),
              const SizedBox(height: 16),
              Text(p.summary),
              const SizedBox(height: 16),
              if ((p.metrics ?? {}).isNotEmpty) ...[
                Text(l10n.projectKeyMetrics, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final e in p.metrics!.entries)
                      Chip(label: Text('${e.key}: ${e.value}')),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              Wrap(spacing: 12, children: [
                if (p.repo != null)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.code),
                    label: Text(l10n.projectRepository),
                    onPressed: () => launchUrl(p.repo!),
                  ),
                if (p.demo != null)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.open_in_new),
                    label: Text(l10n.projectDemo),
                    onPressed: () => launchUrl(p.demo!),
                  ),
              ]),
              const SizedBox(height: 24),
              if (p.body != null) ...[
                Text(l10n.projectCaseStudy, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                bodyAsync.when(
                  data: (md) => md == null
                      ? Text(l10n.projectNoDetail)
                      : Markdown(
                          data: md,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          onTapLink: (text, href, title) {
                            if (href != null) launchUrl(Uri.parse(href));
                          },
                          syntaxHighlighter: AppSyntaxHighlighter(Theme.of(context).textTheme),
                        ),
                  error: (e, st) => Text(l10n.projectLoadBodyError(e.toString())),
                  loading: () => const LinearProgressIndicator(),
                ),
              ],
            ],
          ),
        );
      },
      error: (e, st) => Center(child: Text(l10n.projectLoadError(e.toString()))),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
