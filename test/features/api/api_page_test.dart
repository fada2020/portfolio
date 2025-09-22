import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/features/api/api_page.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/state/openapi_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('BaseUrlField persists user input and updates provider state', (tester) async {
    final container = ProviderContainer(overrides: [
      openApiBaseUrlProvider.overrideWith((ref) async => 'https://api.example.com'),
    ]);

    Future<void> pump() async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('ko')],
            home: const Scaffold(body: BaseUrlField(width: 320)),
          ),
        ),
      );
    }

    await pump();
    await tester.pumpAndSettle();

    const overrideValue = 'https://override.dev';
    final fieldFinder = find.byKey(const Key('api_base_url_field'));
    expect(fieldFinder, findsOneWidget);
    await tester.tap(fieldFinder);
    await tester.pump();
    await tester.enterText(fieldFinder, overrideValue);
    await tester.pump();

    expect(container.read(apiBaseUrlOverrideProvider), overrideValue);

    await pump();
    await tester.pump();

    expect(find.text(overrideValue), findsOneWidget);
  });
}
