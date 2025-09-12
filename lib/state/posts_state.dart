import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/post.dart';
import 'package:portfolio/services/content_loader.dart';

final postsProvider = FutureProvider.family<List<PostMeta>, String>((ref, localeCode) async {
  return loadPosts(localeCode);
});

final postByIdProvider = FutureProvider.family<PostMeta?, ({String localeCode, String id})>((ref, args) async {
  final list = await ref.watch(postsProvider(args.localeCode).future);
  for (final p in list) {
    if (p.id == args.id) return p;
  }
  return null;
});

final postBodyProvider = FutureProvider.family<String?, ({String localeCode, String path})>((ref, args) async {
  return loadPostBody(args.localeCode, args.path);
});

final postSearchQueryProvider = StateProvider<String>((ref) => '');
final postSelectedTagProvider = StateProvider<String?>((ref) => null);

final filteredPostsProvider = FutureProvider.family<List<PostMeta>, String>((ref, localeCode) async {
  final items = await ref.watch(postsProvider(localeCode).future);
  final q = ref.watch(postSearchQueryProvider).trim().toLowerCase();
  final tag = ref.watch(postSelectedTagProvider);
  return items.where((p) {
    final matchQ = q.isEmpty || p.title.toLowerCase().contains(q);
    final matchT = tag == null || p.tags.contains(tag);
    return matchQ && matchT;
  }).toList();
});

final postExcerptProvider = FutureProvider.family<String, ({String localeCode, String path})>((ref, args) async {
  final body = await ref.watch(postBodyProvider((localeCode: args.localeCode, path: args.path)).future) ?? '';
  String text = body;
  // Strip fenced code blocks
  text = text.replaceAll(RegExp(r'```[\s\S]*?```', multiLine: true), '');
  // Strip inline code
  text = text.replaceAll(RegExp(r'`[^`]*`'), '');
  // Strip links/images to their alt/text
  text = text.replaceAllMapped(RegExp(r'!\[[^\]]*\]\([^\)]*\)'), (_) => '');
  text = text.replaceAllMapped(RegExp(r'\[([^\]]+)\]\([^\)]*\)'), (m) => m.group(1) ?? '');
  // Strip headings/formatting
  text = text.replaceAll(RegExp(r'^#{1,6}\s*', multiLine: true), '');
  text = text.replaceAll(RegExp(r'[*_>#-]'), ' ');
  text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (text.length > 200) text = text.substring(0, 200) + '…';
  return text;
});
