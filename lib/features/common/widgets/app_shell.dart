import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/state/locale_state.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final router = GoRouter.of(context);
    // URL query ?lang=ko|en -> apply once
    final uri = router.routeInformationProvider.value.uri;
    final lang = uri.queryParameters['lang'];
    if (lang == 'ko' || lang == 'en') {
      final current = ref.read(selectedLocaleProvider);
      if (current?.languageCode != lang) {
        setLocale(ref, Locale(lang!));
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          _NavButton(label: l10n.navHome, route: '/'),
          _NavButton(label: l10n.navProjects, route: '/projects'),
          _NavButton(label: l10n.navApi, route: '/api'),
          _NavButton(label: l10n.navBlog, route: '/blog'),
          _NavButton(label: l10n.navResume, route: '/resume'),
          _NavButton(label: l10n.navContact, route: '/contact'),
          const SizedBox(width: 8),
          _LangMenu(),
          const SizedBox(width: 8),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}

class _NavButton extends ConsumerWidget {
  const _NavButton({required this.label, required this.route});
  final String label;
  final String route;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = GoRouter.of(context).routeInformationProvider.value.uri.toString();
    final selected = current == route;
    return TextButton(
      onPressed: () => context.go(route),
      child: Text(label, style: TextStyle(fontWeight: selected ? FontWeight.bold : null)),
    );
  }
}

class _LangMenu extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      onSelected: (loc) => setLocale(ref, loc),
      itemBuilder: (context) => [
        PopupMenuItem(value: const Locale('ko'), child: Text(l10n.languageKorean)),
        PopupMenuItem(value: const Locale('en'), child: Text(l10n.languageEnglish)),
      ],
      tooltip: 'Language',
    );
  }
}
