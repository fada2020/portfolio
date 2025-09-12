import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/services/content_loader.dart';

final projectsProvider = FutureProvider.family<List<Project>, String>((ref, localeCode) async {
  return loadProjects(localeCode);
});

final projectByIdProvider = FutureProvider.family<Project?, ({String localeCode, String id})>((ref, args) async {
  final list = await ref.watch(projectsProvider(args.localeCode).future);
  for (final p in list) {
    if (p.id == args.id) return p;
  }
  return null;
});

final projectBodyProvider = FutureProvider.family<String?, ({String localeCode, String? path})>((ref, args) async {
  return loadProjectBody(args.localeCode, args.path);
});
