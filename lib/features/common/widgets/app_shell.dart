import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/state/locale_state.dart';
import 'package:portfolio/state/theme_state.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.child});
  final Widget? child;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  final FocusNode _contentFocus = FocusNode(debugLabel: 'MainContent');
  final FocusNode _menuButtonFocus = FocusNode(debugLabel: 'MenuButton');
  final GlobalKey _contentKey = GlobalKey(debugLabel: 'MainContentKey');

  @override
  void dispose() {
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
              ? Builder(
                  builder: (buttonContext) => IconButton(
                    focusNode: _menuButtonFocus,
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(buttonContext).openDrawer(),
                    tooltip: l10n.commonMenu,
                  ),
                )
              : null,
          actions: isNarrow
              ? [
                  const SizedBox(width: 8),
                  _ThemeModeToggle(compact: true),
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
                  _ThemeModeToggle(compact: false),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => context.go('/search'),
                    tooltip: l10n.navSearch,
                  ),
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
                              Future.microtask(
                                  () => _menuButtonFocus.requestFocus());
                            },
                          )),
                      ListTile(
                        leading: const Icon(Icons.layers),
                        title: Text(l10n.navProjects),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go('/projects');
                          Future.microtask(
                              () => _menuButtonFocus.requestFocus());
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.api),
                        title: Text(l10n.navApi),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go('/api');
                          Future.microtask(
                              () => _menuButtonFocus.requestFocus());
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.forum),
                        title: Text(l10n.navBlog),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go('/blog');
                          Future.microtask(
                              () => _menuButtonFocus.requestFocus());
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.picture_as_pdf),
                        title: Text(l10n.navResume),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go('/resume');
                          Future.microtask(
                              () => _menuButtonFocus.requestFocus());
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.contact_mail),
                        title: Text(l10n.navContact),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go('/contact');
                          Future.microtask(
                              () => _menuButtonFocus.requestFocus());
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.search),
                        title: Text(l10n.navSearch),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go('/search');
                          Future.microtask(
                              () => _menuButtonFocus.requestFocus());
                        },
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(l10n.commonLanguage,
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: Text(l10n.languageKorean),
                        onTap: () {
                          setLocale(ref, const Locale('ko'));
                          Navigator.of(context).pop();
                          Future.microtask(
                              () => _menuButtonFocus.requestFocus());
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: Text(l10n.languageEnglish),
                        onTap: () {
                          setLocale(ref, const Locale('en'));
                          Navigator.of(context).pop();
                          Future.microtask(
                              () => _menuButtonFocus.requestFocus());
                        },
                      ),
                    ],
                  ),
                ),
              )
            : null,
        body: Focus(
          focusNode: _contentFocus,
          child: AnimatedSwitcher(
            key: _contentKey,
            duration: const Duration(milliseconds: 200),
            child: widget.child ?? const SizedBox.shrink(),
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Text('© ${DateTime.now().year}',
                      style: Theme.of(context).textTheme.bodySmall),
                  const Spacer(),
                  TextButton(
                    onPressed: () => context.go('/privacy'),
                    child: Text(l10n.privacyTitle),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => context.go('/privacy-app'),
                    child: Text(l10n.appPrivacyTitle),
                  ),
                ],
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
    final current =
        GoRouter.of(context).routeInformationProvider.value.uri.toString();
    final selected = current == route;
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      child: TextButton(
        onPressed: () => context.go(route),
        child: Text(label,
            style: TextStyle(fontWeight: selected ? FontWeight.bold : null)),
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
        PopupMenuItem(
            value: const Locale('ko'), child: Text(l10n.languageKorean)),
        PopupMenuItem(
            value: const Locale('en'), child: Text(l10n.languageEnglish)),
      ],
    );
  }
}

class _ThemeModeToggle extends ConsumerWidget {
  const _ThemeModeToggle({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selected = ref.watch(selectedThemeModeProvider);
    final saved = ref.watch(savedThemeModeProvider);
    final current = selected ?? saved.value ?? ThemeMode.system;

    void cycle() {
      final next = switch (current) {
        ThemeMode.system => ThemeMode.light,
        ThemeMode.light => ThemeMode.dark,
        ThemeMode.dark => ThemeMode.system,
      };
      setThemeMode(ref, next);
    }

    final iconData = switch (current) {
      ThemeMode.system => Icons.auto_mode_rounded,
      ThemeMode.light => Icons.light_mode_rounded,
      ThemeMode.dark => Icons.dark_mode_rounded,
    };

    final label = switch (current) {
      ThemeMode.system => l10n.themeModeSystem,
      ThemeMode.light => l10n.themeModeLight,
      ThemeMode.dark => l10n.themeModeDark,
    };

    final tooltip = '${l10n.commonToggleTheme} • $label';

    if (compact) {
      return IconButton(
        tooltip: tooltip,
        onPressed: cycle,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          ),
          child: Icon(iconData, key: ValueKey(current)),
        ),
      );
    }

    return Tooltip(
      message: tooltip,
      child: TextButton.icon(
        onPressed: cycle,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          ),
          child: Icon(iconData, key: ValueKey(current)),
        ),
        label: Text(label),
      ),
    );
  }
}
