import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/features/resume/resume_page.dart';

void main() {
  testWidgets('ResumePage shows Download Resume button', (tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: [Locale('en'), Locale('ko')],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: ResumePage(),
      ),
    ));

    await tester.pumpAndSettle();
    expect(find.text('Download Resume'), findsOneWidget);
  });
}

