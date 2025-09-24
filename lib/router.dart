// 라우팅 설정을 위한 패키지들
import 'package:flutter_riverpod/flutter_riverpod.dart';          // Riverpod Provider 시스템
import 'package:go_router/go_router.dart';                       // 선언적 라우팅을 위한 GoRouter

// 각 기능별 페이지들을 임포트
import 'package:portfolio/features/api/api_page.dart';           // API 문서 페이지
import 'package:portfolio/features/blog/blog_detail_page.dart';  // 블로그 상세 페이지
import 'package:portfolio/features/blog/blog_page.dart';         // 블로그 목록 페이지
import 'package:portfolio/features/common/not_found_page.dart';  // 404 에러 페이지
import 'package:portfolio/features/common/widgets/app_shell.dart'; // 공통 레이아웃 (헤더, 네비게이션)
import 'package:portfolio/features/contact/contact_page.dart';    // 연락처 페이지
import 'package:portfolio/features/home/home_page.dart';          // 홈페이지
import 'package:portfolio/features/privacy/privacy_page.dart';    // 프라이버시 정책 페이지
import 'package:portfolio/features/privacy/app_privacy_page.dart'; // 앱 프라이버시 정책 페이지
import 'package:portfolio/features/projects/project_detail_page.dart'; // 프로젝트 상세 페이지
import 'package:portfolio/features/projects/projects_page.dart';  // 프로젝트 목록 페이지
import 'package:portfolio/features/resume/resume_page.dart';      // 이력서 페이지
import 'package:portfolio/features/search/search_page.dart';      // 검색 페이지

/// GoRouter 설정을 제공하는 Provider
/// 앱의 모든 페이지 라우팅을 중앙에서 관리함
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      // ShellRoute: 공통 레이아웃(AppShell)을 모든 하위 페이지에 적용
      // 예: 모든 페이지에서 동일한 헤더와 네비게이션 바를 공유
      ShellRoute(
        // 모든 하위 페이지를 AppShell로 감싸서 공통 레이아웃 제공
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          // 메인 페이지 라우트들
          GoRoute(
            path: '/',                                        // 홈 페이지 (/)
            builder: (context, state) => const HomePage()
          ),

          // 프로젝트 관련 라우트들
          GoRoute(
            path: '/projects',                                // 프로젝트 목록 페이지
            builder: (context, state) => const ProjectsPage()
          ),
          GoRoute(
            path: '/projects/:id',                            // 프로젝트 상세 페이지
            // URL에서 :id 파라미터를 추출하여 ProjectDetailPage에 전달
            builder: (context, state) => ProjectDetailPage(
              id: state.pathParameters['id']!                // 느낌표(!)는 null이 아님을 보장
            ),
          ),

          // API 문서 페이지
          GoRoute(
            path: '/api',
            builder: (context, state) => const ApiPage()
          ),

          // 블로그 관련 라우트들
          GoRoute(
            path: '/blog',                                    // 블로그 목록 페이지
            builder: (context, state) => const BlogPage()
          ),
          GoRoute(
            path: '/blog/:id',                                // 블로그 상세 페이지
            // URL에서 블로그 포스트 ID를 추출하여 상세 페이지에 전달
            builder: (context, state) => BlogDetailPage(
              id: state.pathParameters['id']!
            ),
          ),

          // 기타 정적 페이지들
          GoRoute(
            path: '/resume',                                  // 이력서 페이지
            builder: (context, state) => const ResumePage()
          ),
          GoRoute(
            path: '/contact',                                 // 연락처 페이지
            builder: (context, state) => const ContactPage()
          ),
          GoRoute(
            path: '/search',                                  // 검색 페이지
            builder: (context, state) => const SearchPage()
          ),

          // 정책 관련 페이지들
          GoRoute(
            path: '/privacy',                                 // 웹사이트 프라이버시 정책
            builder: (context, state) => const PrivacyPage()
          ),
          GoRoute(
            path: '/privacy-app',                             // 앱 프라이버시 정책
            builder: (context, state) => const AppPrivacyPage()
          ),
        ],
      ),
    ],

    // 라우트를 찾을 수 없을 때 (404 에러) 표시할 페이지
    errorBuilder: (context, state) => const NotFoundPage(),

    // 디버그 모드에서 라우팅 로그 출력 여부 (false로 설정하여 콘솔 정리)
    debugLogDiagnostics: false,
  );
});
