import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

Future<List<String>> _projectIds() async {
  final en = await File('assets/contents/en/projects.yaml').readAsString().catchError((_) => '[]');
  final ko = await File('assets/contents/ko/projects.yaml').readAsString().catchError((_) => '[]');
  final ids = <String>{};
  for (final raw in [en, ko]) {
    final list = loadYaml(raw);
    if (list is YamlList) {
      for (final e in list) {
        if (e is YamlMap && e['id'] != null) ids.add(e['id'].toString());
      }
    }
  }
  return ids.toList()..sort();
}

Future<List<String>> _postIds() async {
  final en = await File('assets/contents/en/posts.yaml').readAsString().catchError((_) => '[]');
  final ko = await File('assets/contents/ko/posts.yaml').readAsString().catchError((_) => '[]');
  final ids = <String>{};
  for (final raw in [en, ko]) {
    final list = loadYaml(raw);
    if (list is YamlList) {
      for (final e in list) {
        if (e is YamlMap && e['id'] != null) ids.add(e['id'].toString());
      }
    }
  }
  return ids.toList()..sort();
}

String _fullUrl(String base, String path) {
  final b = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
  return '$b$path';
}

Future<void> main(List<String> args) async {
  final outDir = (args.length >= 2 && args[0] == '--out') ? args[1] : 'build/web';
  final base = Platform.environment['SITE_BASE_URL'] ?? 'https://example.com';
  final now = DateTime.now().toUtc().toIso8601String().split('.').first + 'Z';

  final entries = <String>{
    '/',
    '/projects',
    '/api',
    '/blog',
    '/resume',
    '/contact',
  };
  final pids = await _projectIds();
  for (final id in pids) {
    entries.add('/projects/$id');
  }
  final posts = await _postIds();
  for (final id in posts) {
    entries.add('/blog/$id');
  }

  final buf = StringBuffer()
    ..writeln('<?xml version="1.0" encoding="UTF-8"?>')
    ..writeln('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">');
  for (final path in entries) {
    buf
      ..writeln('  <url>')
      ..writeln('    <loc>${_fullUrl(base, path)}</loc>')
      ..writeln('    <lastmod>$now</lastmod>')
      ..writeln('    <changefreq>weekly</changefreq>')
      ..writeln('    <priority>${path == '/' ? '1.0' : '0.7'}</priority>')
      ..writeln('  </url>');
  }
  buf.writeln('</urlset>');

  final outPath = '$outDir/sitemap.xml';
  await File(outPath).create(recursive: true);
  await File(outPath).writeAsString(buf.toString());

  final robots = StringBuffer()
    ..writeln('User-agent: *')
    ..writeln('Allow: /')
    ..writeln('Sitemap: ${_fullUrl(base, '/sitemap.xml')}');
  await File('$outDir/robots.txt').writeAsString(robots.toString());

  stdout.writeln('Generated sitemap.xml and robots.txt in $outDir');
}

