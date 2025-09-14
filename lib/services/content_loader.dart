import 'package:flutter/services.dart' show rootBundle;
import 'package:portfolio/models/post.dart';
import 'package:portfolio/models/profile.dart';
import 'package:portfolio/models/project.dart';
import 'package:yaml/yaml.dart';

Future<List<Project>> loadProjects(String localeCode) async {
  final code = (localeCode == 'ko') ? 'ko' : 'en';
  final path = 'assets/contents/$code/projects.yaml';
  final raw = await rootBundle.loadString(path);
  final yaml = loadYaml(raw) as YamlList;
  return yaml.map((e) => Project.fromMap(Map<String, dynamic>.from(e))).toList();
}

Future<List<PostMeta>> loadPosts(String localeCode) async {
  final code = (localeCode == 'ko') ? 'ko' : 'en';
  final path = 'assets/contents/$code/posts.yaml';
  final raw = await rootBundle.loadString(path);
  final yaml = loadYaml(raw) as YamlList;
  final list = yaml.map((e) => PostMeta.fromMap(Map<String, dynamic>.from(e))).toList();
  list.sort((a, b) => b.date.compareTo(a.date));
  return list;
}

Future<String?> loadPostBody(String localeCode, String relativePath) async {
  final code = (localeCode == 'ko') ? 'ko' : 'en';
  final path = 'assets/contents/$code/$relativePath';
  try {
    return await rootBundle.loadString(path);
  } catch (_) {
    return null;
  }
}

Future<Profile> loadProfile(String localeCode) async {
  final code = (localeCode == 'ko') ? 'ko' : 'en';
  final path = 'assets/contents/$code/profile.yaml';
  final raw = await rootBundle.loadString(path);
  final yaml = loadYaml(raw) as YamlMap;
  return Profile.fromMap(Map<String, dynamic>.from(yaml));
}

Future<String?> loadProjectBody(String localeCode, String? relativePath) async {
  if (relativePath == null || relativePath.isEmpty) return null;
  final code = (localeCode == 'ko') ? 'ko' : 'en';
  final path = 'assets/contents/$code/$relativePath';
  try {
    return await rootBundle.loadString(path);
  } catch (_) {
    return null;
  }
}
