import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/state/profile_state.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final async = ref.watch(profileProvider(localeCode));
    return async.when(
      data: (p) {
        final links = p.links;
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                if (links['email'] != null)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.email),
                    label: Text(links['email']!),
                    onPressed: () => launchUrl(Uri.parse('mailto:${links['email']}')),
                  ),
                if (links['github'] != null)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.code),
                    label: const Text('GitHub'),
                    onPressed: () => launchUrl(Uri.parse(links['github']!)),
                  ),
                if (links['linkedin'] != null)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.business),
                    label: const Text('LinkedIn'),
                    onPressed: () => launchUrl(Uri.parse(links['linkedin']!)),
                  ),
              ],
            ),
          ),
        );
      },
      error: (e, st) => Center(child: Text('Failed to load profile: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
