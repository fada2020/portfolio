import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/state/profile_state.dart';
import 'package:url_launcher/url_launcher.dart';

class ResumePage extends ConsumerWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final async = ref.watch(profileProvider(localeCode));
    return async.when(
      data: (p) {
        final links = p.links;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(p.name, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text('${p.title} · ${p.location}', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  Text('Summary', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...p.summary.map((s) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• '),
                            Expanded(child: Text(s)),
                          ],
                        ),
                      )),
                  const SizedBox(height: 16),
                  Wrap(spacing: 12, children: [
                    if (links['resume_url'] != null)
                      OutlinedButton.icon(
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Download Resume'),
                        onPressed: () => launchUrl(Uri.parse(links['resume_url']!)),
                      ),
                    if (links['github'] != null)
                      OutlinedButton.icon(
                        icon: const Icon(Icons.code),
                        label: const Text('GitHub'),
                        onPressed: () => launchUrl(Uri.parse(links['github']!)),
                      ),
                    if (links['linkedin'] != null)
                      OutlinedButton.icon(
                        icon: const Icon(Icons.business),
                        label: const Text('LinkedIn'),
                        onPressed: () => launchUrl(Uri.parse(links['linkedin']!)),
                      ),
                    if (links['email'] != null)
                      OutlinedButton.icon(
                        icon: const Icon(Icons.email),
                        label: const Text('Email'),
                        onPressed: () => launchUrl(Uri.parse('mailto:${links['email']}')),
                      ),
                  ]),
                ],
              ),
            ),
            ),
          ),
        );
      },
      error: (e, st) => Center(child: Text('Failed to load profile: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
