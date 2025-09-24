import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/router.dart';
import 'package:portfolio/state/locale_state.dart';
import 'package:portfolio/state/theme_state.dart';
import 'package:portfolio/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: PortfolioApp()));
}

class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = () {
      final selected = ref.watch(selectedLocaleProvider);
      final saved = ref.watch(savedLocaleProvider);
      if (selected != null) return selected;
      if (saved.hasValue && saved.value != null) return saved.value;
      return null; // Use system/browser locale
    }();
    final router = ref.watch(routerProvider);
    final themeMode = () {
      final selected = ref.watch(selectedThemeModeProvider);
      final saved = ref.watch(savedThemeModeProvider);
      if (selected != null) return selected;
      if (saved.hasValue && saved.value != null) {
        return saved.value!;
      }
      return ThemeMode.system;
    }();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Portfolio',
      routerConfig: router,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ko')],
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      themeAnimationDuration: const Duration(milliseconds: 380),
      themeAnimationCurve: Curves.easeInOutCubic,
    );
  }
}
