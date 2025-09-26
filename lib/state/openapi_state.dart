import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/openapi.dart';
import 'package:portfolio/services/openapi_loader.dart';

// Provider for all OpenAPI specs
final allOpenApiSpecsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return loadAllOpenApiSpecs();
});

// Provider for single spec (backward compatibility)
final openApiSpecProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return loadOpenApiSpec();
});

// Provider for all endpoints from all specs
final openApiEndpointsProvider = FutureProvider<List<ApiEndpoint>>((ref) async {
  return loadAllOpenApiEndpoints();
});

// Provider for available API specs
final availableApiSpecsProvider =
    StateProvider<List<String>>((ref) => apiSpecs);

final openApiBaseUrlProvider = FutureProvider<String>((ref) async {
  return await loadOpenApiServerUrl() ??
      'https://portfolio-np8b1i8j2-fada2020s-projects.vercel.app';
});

final apiSearchQueryProvider = StateProvider<String>((ref) => '');
final apiSelectedTagProvider = StateProvider<String?>((ref) => null);
final apiGroupByTagProvider = StateProvider<bool>((ref) => false);
final apiIncludeAuthProvider = StateProvider<bool>((ref) => false);
final apiAuthTokenProvider = StateProvider<String>((ref) => '');
final apiBaseUrlOverrideProvider = StateProvider<String?>((ref) => null);
final apiMockModeProvider = StateProvider<bool>((ref) => false);

final filteredEndpointsProvider =
    FutureProvider<List<ApiEndpoint>>((ref) async {
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
