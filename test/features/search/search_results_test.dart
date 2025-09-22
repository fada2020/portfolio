import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/features/common/widgets/search_widget.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/models/post.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/state/search_state.dart' as search_state;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final project = Project(
    id: 'api-showcase',
    title: 'API Showcase',
    period: '2024',
    stack: const ['Dart'],
    domains: const ['API'],
    role: 'Developer',
    summary: 'API tooling',
  );

  final post = PostMeta(
    id: 'api-hardening',
    title: 'API Hardening',
    date: DateTime(2024, 3, 10),
    tags: const ['Security'],
    body: 'posts/api-hardening.md',
  );

  testWidgets('SearchResults renders localized summary for query', (tester) async {
    final results = search_state.SearchResults(projects: [project], posts: [post], query: 'api');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          search_state.searchQueryProvider.overrideWith((ref) => 'api'),
          search_state.searchResultsProvider.overrideWith((ref, locale) => results),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ko')],
          home: const Scaffold(body: SearchResults(localeCode: 'en')),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('API Showcase'), findsOneWidget);
    expect(find.text('API Hardening'), findsOneWidget);
    expect(find.text('Mar 10, 2024'), findsOneWidget);
  });
}
