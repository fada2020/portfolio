import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:portfolio/services/content_loader.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('loadProjects loads EN sample projects', () async {
    final list = await loadProjects('en');
    expect(list, isNotEmpty);
    expect(list.first.id, isNotEmpty);
  });

  test('loadProjectBody loads Markdown content', () async {
    final md = await loadProjectBody('en', 'projects/svc-gateway.md');
    expect(md, isNotNull);
    expect(md!.contains('# Architecture'), true);
  });

  test('loadPosts loads EN posts', () async {
    final posts = await loadPosts('en');
    expect(posts, isNotEmpty);
    expect(posts.first.id, isNotEmpty);
  });
}

