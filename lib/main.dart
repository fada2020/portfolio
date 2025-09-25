// Flutter 프레임워크 및 관련 패키지 임포트
import 'package:flutter/material.dart';                     // Flutter의 Material Design 위젯들
import 'package:flutter_localizations/flutter_localizations.dart'; // 국제화 지원을 위한 localization delegates
import 'package:flutter_riverpod/flutter_riverpod.dart';    // 상태 관리를 위한 Riverpod 패키지
import 'package:portfolio/l10n/app_localizations.dart';     // 앱의 커스텀 localization 파일
import 'package:portfolio/router.dart';                     // GoRouter 설정이 담긴 라우터
import 'package:portfolio/state/locale_state.dart';         // 언어 선택 상태 관리
import 'package:portfolio/state/theme_state.dart';          // 테마(다크/라이트 모드) 상태 관리
import 'package:portfolio/theme/app_theme.dart';            // 앱의 커스텀 테마 정의
import 'package:portfolio/utils/performance.dart';          // 성능 모니터링 유틸리티

/// 앱의 진입점(Entry Point)
/// Flutter 앱이 시작될 때 가장 먼저 실행되는 함수
void main() {
  // 성능 모니터링 초기화 (Core Web Vitals 추적)
  PerformanceMonitor.initialize();

  // ProviderScope로 전체 앱을 감싸서 Riverpod 상태 관리 시스템을 활성화
  // 이를 통해 앱 전체에서 Provider를 사용할 수 있게 됨
  runApp(const ProviderScope(child: PortfolioApp()));
}

/// 포트폴리오 앱의 루트 위젯
/// ConsumerWidget을 상속하여 Riverpod의 상태를 직접 구독할 수 있음
class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 언어 설정 우선순위 결정 로직
    // 1순위: 사용자가 직접 선택한 언어 (selectedLocaleProvider)
    // 2순위: 로컬 스토리지에 저장된 언어 (savedLocaleProvider)
    // 3순위: 시스템/브라우저 기본 언어 (null 반환시 시스템 기본값 사용)
    final locale = () {
      final selected = ref.watch(selectedLocaleProvider);  // 현재 세션에서 선택된 언어
      final saved = ref.watch(savedLocaleProvider);        // 저장된 언어 설정

      if (selected != null) return selected;              // 사용자가 직접 선택한 언어가 최우선
      if (saved.hasValue && saved.value != null) return saved.value; // 저장된 설정이 다음 우선
      return null; // 시스템 기본 언어 사용
    }();

    // GoRouter 인스턴스를 가져옴 (모든 페이지 라우팅을 담당)
    final router = ref.watch(routerProvider);

    // 테마 모드 설정 우선순위 결정 로직 (라이트/다크/시스템 모드)
    // 언어 설정과 동일한 우선순위 로직을 따름
    final themeMode = () {
      final selected = ref.watch(selectedThemeModeProvider); // 현재 세션에서 선택된 테마
      final saved = ref.watch(savedThemeModeProvider);       // 저장된 테마 설정

      if (selected != null) return selected;
      if (saved.hasValue && saved.value != null) {
        return saved.value!;
      }
      return ThemeMode.system; // 기본값: 시스템 테마 따라가기
    }();

    // MaterialApp.router를 반환하여 전체 앱을 구성
    return MaterialApp.router(
      // 개발 중 디버그 배너 숨김 (우측 상단의 "DEBUG" 배너)
      debugShowCheckedModeBanner: false,

      // 앱 제목 (브라우저 탭 제목으로 표시됨)
      title: 'Portfolio',

      // GoRouter 설정 적용 (페이지 라우팅 담당)
      routerConfig: router,

      // 현재 설정된 언어 적용
      locale: locale,

      // 국제화 지원을 위한 delegates 설정
      // 각각 다른 종류의 위젯들에 대한 번역을 제공
      localizationsDelegates: const [
        AppLocalizations.delegate,              // 앱 커스텀 번역
        GlobalMaterialLocalizations.delegate,   // Material 위젯 번역 (버튼, 다이얼로그 등)
        GlobalWidgetsLocalizations.delegate,    // 기본 위젯 번역
        GlobalCupertinoLocalizations.delegate,  // iOS 스타일 위젯 번역
      ],

      // 지원하는 언어 목록 (영어, 한국어)
      supportedLocales: const [Locale('en'), Locale('ko')],

      // 라이트 모드 테마 설정
      theme: AppTheme.light,

      // 다크 모드 테마 설정
      darkTheme: AppTheme.dark,

      // 현재 테마 모드 (light/dark/system)
      themeMode: themeMode,

      // 테마 전환 시 애니메이션 지속시간
      themeAnimationDuration: const Duration(milliseconds: 380),

      // 테마 전환 애니메이션 곡선 (부드러운 전환 효과)
      themeAnimationCurve: Curves.easeInOutCubic,
    );
  }
}
