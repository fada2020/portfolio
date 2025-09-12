import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/openapi.dart';
import 'package:portfolio/services/openapi_loader.dart';

final openApiSpecProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return loadOpenApiSpec();
});

final openApiEndpointsProvider = FutureProvider<List<ApiEndpoint>>((ref) async {
  return loadOpenApi();
});

final openApiBaseUrlProvider = FutureProvider<String>((ref) async {
  return await loadOpenApiServerUrl() ?? 'https://api.example.com';
});

final apiSearchQueryProvider = StateProvider<String>((ref) => '');
final apiSelectedTagProvider = StateProvider<String?>((ref) => null);
final apiGroupByTagProvider = StateProvider<bool>((ref) => false);
final apiIncludeAuthProvider = StateProvider<bool>((ref) => false);
final apiAuthTokenProvider = StateProvider<String>((ref) => '');

final filteredEndpointsProvider = FutureProvider<List<ApiEndpoint>>((ref) async {
  final list = await ref.watch(openApiEndpointsProvider.future);
  final q = ref.watch(apiSearchQueryProvider).trim().toLowerCase();
  final tag = ref.watch(apiSelectedTagProvider);
  return list.where((e) {
    final matchQ = q.isEmpty ||
        e.path.toLowerCase().contains(q) ||
        (e.summary ?? '').toLowerCase().contains(q) ||
        (e.operationId ?? '').toLowerCase().contains(q);
    final matchT = tag == null || e.tags.contains(tag);
    return matchQ && matchT;
  }).toList()
    ..sort((a, b) => a.path.compareTo(b.path));
});
