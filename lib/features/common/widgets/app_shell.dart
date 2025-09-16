import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/state/locale_state.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.child});
  final Widget? child;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  final FocusNode _skipFocus = FocusNode(debugLabel: 'SkipToContent');
  final FocusNode _contentFocus = FocusNode(debugLabel: 'MainContent');
  final FocusNode _menuButtonFocus = FocusNode(debugLabel: 'MenuButton');

  @override
  void dispose() {
    _skipFocus.dispose();
    _contentFocus.dispose();
    _menuButtonFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    return LayoutBuilder(builder: (context, constraints) {
      final isNarrow = constraints.maxWidth < 720;
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.appTitle),
          leading: isNarrow
              ? IconButton(
                  focusNode: _menuButtonFocus,
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  tooltip: l10n.commonMenu,
                )
              : null,
          actions: isNarrow
              ? [
                  const SizedBox(width: 8),
                  _LangMenu(tooltip: l10n.commonLanguage),
                  const SizedBox(width: 8),
                ]
              : [
                  _NavButton(label: l10n.navHome, route: '/'),
                  _NavButton(label: l10n.navProjects, route: '/projects'),
                  _NavButton(label: l10n.navApi, route: '/api'),
                  _NavButton(label: l10n.navBlog, route: '/blog'),
                  _NavButton(label: l10n.navResume, route: '/resume'),
                  _NavButton(label: l10n.navContact, route: '/contact'),
                  const SizedBox(width: 8),
                  _LangMenu(tooltip: l10n.commonLanguage),
                  const SizedBox(width: 8),
                ],
        ),
        drawer: isNarrow
            ? Drawer(
                child: SafeArea(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Focus(
                        autofocus: true,
                        child: ListTile(
                        leading: const Icon(Icons.home),
                        title: Text(l10n.navHome),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go('/');
                          Future.microtask(() => _menuButtonFocus.requestFocus());
                        },
                      )),
                      ListTile(
                        leading: const Icon(Icons.layers),
                        title: Text(l10n.navProjects),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go('/projects');
                          Future.microtask(() => _menuButtonFocus.requestFocus());
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.api),
                        title: Text(l10n.navApi),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go('/api');
                          Future.microtask(() => _menuButtonFocus.requestFocus());
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.forum),
                        title: Text(l10n.navBlog),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go('/blog');
                          Future.microtask(() => _menuButtonFocus.requestFocus());
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.picture_as_pdf),
                        title: Text(l10n.navResume),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go('/resume');
                          Future.microtask(() => _menuButtonFocus.requestFocus());
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.contact_mail),
                        title: Text(l10n.navContact),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go('/contact');
                          Future.microtask(() => _menuButtonFocus.requestFocus());
                        },
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(l10n.commonLanguage, style: Theme.of(context).textTheme.bodySmall),
                      ),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: Text(l10n.languageKorean),
                        onTap: () {
                          setLocale(ref, const Locale('ko'));
                          Navigator.of(context).pop();
                          Future.microtask(() => _menuButtonFocus.requestFocus());
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: Text(l10n.languageEnglish),
                        onTap: () {
                          setLocale(ref, const Locale('en'));
                          Navigator.of(context).pop();
                          Future.microtask(() => _menuButtonFocus.requestFocus());
                        },
                      ),
                    ],
                  ),
                ),
              )
            : null,
        body: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: Focus(
                  focusNode: _skipFocus,
                  child: TextButton(
                    style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                    onPressed: () => _contentFocus.requestFocus(),
                    child: Text(l10n.skipToContent),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Focus(
                focusNode: _contentFocus,
                child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: widget.child ?? const SizedBox.shrink(),
              ),
              ),
            ),
          ],
        ),
      );
    });
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
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      child: TextButton(
        onPressed: () => context.go(route),
        child: Text(label, style: TextStyle(fontWeight: selected ? FontWeight.bold : null)),
      ),
    );
  }
}

class _LangMenu extends ConsumerWidget {
  const _LangMenu({this.tooltip});
  final String? tooltip;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<Locale>(
      tooltip: tooltip ?? 'Language',
      icon: const Icon(Icons.language),
      onSelected: (loc) => setLocale(ref, loc),
      itemBuilder: (context) => [
        PopupMenuItem(value: const Locale('ko'), child: Text(l10n.languageKorean)),
        PopupMenuItem(value: const Locale('en'), child: Text(l10n.languageEnglish)),
      ],
    );
  }
}
