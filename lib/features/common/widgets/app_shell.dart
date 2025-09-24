// 앱의 공통 레이아웃을 위한 패키지들
import 'package:flutter/material.dart';                    // Flutter UI 위젯들
import 'package:flutter_riverpod/flutter_riverpod.dart';   // 상태 관리
import 'package:go_router/go_router.dart';                // 페이지 라우팅
import 'package:portfolio/l10n/app_localizations.dart';    // 다국어 지원
import 'package:portfolio/state/locale_state.dart';        // 언어 설정 상태
import 'package:portfolio/state/theme_state.dart';         // 테마 설정 상태

/// 앱의 공통 레이아웃을 제공하는 Shell 위젯
/// 모든 페이지에서 공유하는 상단바, 네비게이션, 푸터 등을 포함
/// ConsumerStatefulWidget을 사용하여 상태 변화를 감지하고 반응함
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.child});

  /// 실제 페이지 내용이 들어갈 자식 위젯
  final Widget? child;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  // 접근성을 위한 포커스 노드들
  // 키보드 네비게이션과 스크린 리더 지원을 위해 사용
  final FocusNode _contentFocus = FocusNode(debugLabel: 'MainContent');      // 메인 콘텐츠 영역 포커스
  final FocusNode _menuButtonFocus = FocusNode(debugLabel: 'MenuButton');    // 메뉴 버튼 포커스

  // 메인 콘텐츠를 식별하기 위한 글로벌 키
  final GlobalKey _contentKey = GlobalKey(debugLabel: 'MainContentKey');

  @override
  void dispose() {
    // 메모리 누수 방지를 위해 포커스 노드들을 정리
    _contentFocus.dispose();
    _menuButtonFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 현재 언어에 맞는 번역 텍스트를 가져옴
    final l10n = AppLocalizations.of(context)!;

    // GoRouter 인스턴스를 가져와서 현재 URL 정보를 확인
    final router = GoRouter.of(context);

    // URL 쿼리 파라미터로 언어 전환 지원 (?lang=ko 또는 ?lang=en)
    // 예: https://portfolio.com/projects?lang=ko
    final uri = router.routeInformationProvider.value.uri;
    final lang = uri.queryParameters['lang'];

    // URL에 언어 파라미터가 있고 유효한 언어 코드인 경우
    if (lang == 'ko' || lang == 'en') {
      final current = ref.read(selectedLocaleProvider);   // 현재 선택된 언어 확인
      // 현재 언어와 URL 파라미터 언어가 다른 경우에만 변경
      if (current?.languageCode != lang) {
        setLocale(ref, Locale(lang!));                   // 언어 설정 변경
      }
    }
    // LayoutBuilder: 화면 크기에 따라 다른 레이아웃을 제공
    return LayoutBuilder(builder: (context, constraints) {
      // 반응형 디자인: 720px를 기준으로 모바일/데스크톱 구분
      final isNarrow = constraints.maxWidth < 720;

      return Scaffold(
        // 상단 앱바 설정
        appBar: AppBar(
          // 앱 제목 표시
          title: Text(l10n.appTitle),

          // 모바일 환경에서만 햄버거 메뉴 버튼 표시
          leading: isNarrow
              ? Builder(
                  // Builder를 사용하여 올바른 context에서 drawer를 열 수 있도록 함
                  builder: (buttonContext) => IconButton(
                    focusNode: _menuButtonFocus,           // 접근성을 위한 포커스 관리
                    icon: const Icon(Icons.menu),          // 햄버거 메뉴 아이콘
                    onPressed: () => Scaffold.of(buttonContext).openDrawer(), // 드로어 열기
                    tooltip: l10n.commonMenu,              // 접근성을 위한 툴팁
                  ),
                )
              : null,                                      // 데스크톱에서는 leading 없음
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
