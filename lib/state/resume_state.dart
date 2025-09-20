import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/resume.dart';
import 'package:portfolio/services/content_loader.dart';
import 'package:yaml/yaml.dart';

final resumeProvider = FutureProvider.family<Resume, String>((ref, localeCode) async {
  final contentLoader = ref.watch(contentLoaderProvider);

  try {
    final content = await contentLoader.loadContent(localeCode, 'resume.yaml');
    final yamlDoc = loadYaml(content);

    if (yamlDoc is! Map<String, dynamic>) {
      throw Exception('Invalid resume YAML format');
    }

    return Resume.fromMap(yamlDoc);
  } catch (e) {
    throw Exception('Failed to load resume: $e');
  }
});