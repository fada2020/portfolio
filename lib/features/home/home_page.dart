import 'package:flutter/material.dart';
import 'package:portfolio/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(l10n.appTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          const Text('Build resilient, scalable backends. Show your impact.'),
        ],
      ),
    );
  }
}
