import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/features/api/api_page.dart';
import 'package:portfolio/features/blog/blog_detail_page.dart';
import 'package:portfolio/features/blog/blog_page.dart';
import 'package:portfolio/features/common/not_found_page.dart';
import 'package:portfolio/features/common/widgets/app_shell.dart';
import 'package:portfolio/features/contact/contact_page.dart';
import 'package:portfolio/features/home/home_page.dart';
import 'package:portfolio/features/privacy/privacy_page.dart';
import 'package:portfolio/features/privacy/app_privacy_page.dart';
import 'package:portfolio/features/projects/project_detail_page.dart';
import 'package:portfolio/features/projects/projects_page.dart';
import 'package:portfolio/features/resume/resume_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomePage()),
          GoRoute(path: '/projects', builder: (context, state) => const ProjectsPage()),
          GoRoute(
            path: '/projects/:id',
            builder: (context, state) => ProjectDetailPage(id: state.pathParameters['id']!),
          ),
          GoRoute(path: '/api', builder: (context, state) => const ApiPage()),
          GoRoute(path: '/blog', builder: (context, state) => const BlogPage()),
          GoRoute(
            path: '/blog/:id',
            builder: (context, state) => BlogDetailPage(id: state.pathParameters['id']!),
          ),
          GoRoute(path: '/resume', builder: (context, state) => const ResumePage()),
          GoRoute(path: '/contact', builder: (context, state) => const ContactPage()),
          GoRoute(path: '/privacy', builder: (context, state) => const PrivacyPage()),
          GoRoute(path: '/privacy-app', builder: (context, state) => const AppPrivacyPage()),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
    debugLogDiagnostics: false,
  );
});
