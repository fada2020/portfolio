import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/state/posts_state.dart';
import 'package:portfolio/utils/syntax_highlighter.dart';

class BlogDetailPage extends ConsumerWidget {
  const BlogDetailPage({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final formatter = DateFormat.yMMMMd(AppLocalizations.of(context)!.localeName);
    final postAsync = ref.watch(postByIdProvider((localeCode: localeCode, id: id)));
    return postAsync.when(
      data: (meta) {
        if (meta == null) return const Center(child: Text('Post not found'));
        final bodyAsync = ref.watch(postBodyProvider((localeCode: localeCode, path: meta.body)));
        return Padding(
          padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  Text(meta.title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 6),
                  Text('${formatter.format(meta.date)} · ${meta.tags.join(' · ')}',
                      style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 16),
              bodyAsync.when(
                data: (md) => md == null
                    ? const Text('No content')
                    : Markdown(
                        data: md,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        syntaxHighlighter: AppSyntaxHighlighter(Theme.of(context).textTheme),
                      ),
                error: (e, st) => Text('Failed to load body: $e'),
                loading: () => const LinearProgressIndicator(),
              ),
            ],
          ),
        );
      },
      error: (e, st) => Center(child: Text('Failed to load: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
