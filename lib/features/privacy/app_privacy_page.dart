import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/utils/syntax_highlighter.dart';

class AppPrivacyPage extends StatelessWidget {
  const AppPrivacyPage({super.key});

  Future<String?> _loadMarkdown(String localeCode) async {
    final code = (localeCode == 'ko') ? 'ko' : 'en';
    final path = 'assets/contents/$code/app_privacy.md';
    try {
      return await rootBundle.loadString(path);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;
    return FutureBuilder<String?>(
      future: _loadMarkdown(localeCode),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final md = snap.data;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Text(l10n.appPrivacyTitle, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              if (md == null)
                Text(l10n.errFailedToLoad)
              else
                Markdown(
                  data: md,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  syntaxHighlighter: AppSyntaxHighlighter(Theme.of(context).textTheme),
                ),
            ],
          ),
        );
      },
    );
  }
}

