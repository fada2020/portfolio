import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/features/resume/resume_page.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/models/resume.dart';
import 'package:portfolio/state/resume_state.dart';

void main() {
  testWidgets('ResumePage loads without errors', (tester) async {
    // Create a mock resume
    final mockResume = Resume(
      personal: PersonalInfo(
        name: 'Test User',
        title: 'Software Engineer',
        location: 'Test City',
        email: 'test@example.com',
        github: 'https://github.com/test',
        linkedin: 'https://linkedin.com/in/test',
        summary: 'Test summary',
      ),
      experience: [],
      education: [],
      skills: Skills(
        programmingLanguages: {},
        backendTechnologies: {},
        infrastructure: {},
        dataProcessing: {},
      ),
      certifications: [],
      projectsHighlight: [],
      languages: [],
      interests: [],
    );

    await tester.pumpWidget(ProviderScope(
      overrides: [
        resumeProvider.overrideWith((ref, localeCode) => Future.value(mockResume)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: const [Locale('en'), Locale('ko')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const Scaffold(
          body: SizedBox(
            width: 800, // Provide sufficient width to avoid layout overflow
            height: 600,
            child: ResumePage(),
          ),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    // Just check that the widget tree builds without throwing
    expect(find.byType(ResumePage), findsOneWidget);
  });
}
