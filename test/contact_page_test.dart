import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/features/contact/contact_page.dart';

void main() {
  testWidgets('ContactPage shows GitHub and LinkedIn buttons', (tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: [Locale('en'), Locale('ko')],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: ContactPage(),
      ),
    ));

    await tester.pumpAndSettle();
    expect(find.text('GitHub'), findsOneWidget);
    expect(find.text('LinkedIn'), findsOneWidget);
  });
}

