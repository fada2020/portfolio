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

String _getPriority(String path) {
  switch (path) {
    case '/':
      return '1.0';
    case '/projects':
    case '/blog':
      return '0.9';
    case '/contact':
    case '/resume':
      return '0.8';
    case '/api':
      return '0.7';
    default:
      if (path.startsWith('/projects/') || path.startsWith('/blog/')) {
        return '0.8';
      }
      return '0.6';
  }
}

String _getChangeFreq(String path) {
  switch (path) {
    case '/':
      return 'daily';
    case '/projects':
    case '/blog':
      return 'weekly';
    case '/contact':
    case '/resume':
      return 'monthly';
    default:
      if (path.startsWith('/projects/') || path.startsWith('/blog/')) {
        return 'monthly';
      }
      return 'yearly';
  }
}

Future<void> main(List<String> args) async {
  final outDir = (args.length >= 2 && args[0] == '--out') ? args[1] : 'build/web';
  final base = Platform.environment['SITE_BASE_URL'] ?? 'https://example.com';
  final now = '${DateTime.now().toUtc().toIso8601String().split('.').first}Z';

  final entries = <String>{
    '/',
    '/projects',
    '/api',
    '/blog',
    '/resume',
    '/contact',
    '/privacy',
    '/privacy-app',
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
    ..writeln('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">');

  for (final path in entries) {
    final priority = _getPriority(path);
    final changefreq = _getChangeFreq(path);

    buf
      ..writeln('  <url>')
      ..writeln('    <loc>${_fullUrl(base, path)}</loc>')
      ..writeln('    <lastmod>$now</lastmod>')
      ..writeln('    <changefreq>$changefreq</changefreq>')
      ..writeln('    <priority>$priority</priority>');

    // Add alternate language links for main pages
    if (!path.startsWith('/blog/') && !path.startsWith('/projects/')) {
      buf
        ..writeln('    <xhtml:link rel="alternate" hreflang="en" href="${_fullUrl(base, path)}?lang=en"/>')
        ..writeln('    <xhtml:link rel="alternate" hreflang="ko" href="${_fullUrl(base, path)}?lang=ko"/>');
    }

    buf.writeln('  </url>');
  }
  buf.writeln('</urlset>');

  final outPath = '$outDir/sitemap.xml';
  await File(outPath).create(recursive: true);
  await File(outPath).writeAsString(buf.toString());

  final robots = StringBuffer()
    ..writeln('User-agent: *')
    ..writeln('Allow: /')
    ..writeln('Disallow: /assets/')
    ..writeln('Disallow: /*.dart')
    ..writeln('Disallow: /*.js.map')
    ..writeln('')
    ..writeln('User-agent: Googlebot')
    ..writeln('Allow: /')
    ..writeln('Disallow: /assets/')
    ..writeln('')
    ..writeln('User-agent: Bingbot')
    ..writeln('Allow: /')
    ..writeln('Disallow: /assets/')
    ..writeln('')
    ..writeln('# Crawl delay')
    ..writeln('Crawl-delay: 1')
    ..writeln('')
    ..writeln('# Sitemap')
    ..writeln('Sitemap: ${_fullUrl(base, '/sitemap.xml')}');
  await File('$outDir/robots.txt').writeAsString(robots.toString());

  stdout.writeln('Generated sitemap.xml and robots.txt in $outDir');
}
