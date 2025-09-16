import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/l10n/app_localizations.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 48),
            const SizedBox(height: 12),
            Text(l10n.pageNotFound, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.home),
              label: Text(l10n.goHome),
            ),
          ],
        ),
      ),
    );
  }
}

