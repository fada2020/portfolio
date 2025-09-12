import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:portfolio/models/openapi.dart';

Future<Map<String, dynamic>> loadOpenApiSpec() async {
  final raw = await rootBundle.loadString('assets/openapi/openapi.json');
  return jsonDecode(raw) as Map<String, dynamic>;
}

Future<List<ApiEndpoint>> loadOpenApi() async {
  final json = await loadOpenApiSpec();
  final paths = json['paths'] as Map<String, dynamic>? ?? {};
  final List<ApiEndpoint> endpoints = [];
  for (final entry in paths.entries) {
    final path = entry.key;
    final methods = (entry.value as Map<String, dynamic>);
    for (final m in methods.entries) {
      final method = m.key.toUpperCase();
      final op = (m.value as Map<String, dynamic>);
      final tags = ((op['tags'] as List?)?.map((e) => e.toString()).toList() ?? []);
      final params = ((op['parameters'] as List?) ?? [])
          .map((p) => ApiParameter(
                name: p['name']?.toString() ?? '',
                location: p['in']?.toString() ?? 'query',
                required: (p['required'] as bool?) ?? false,
                schema: (p['schema'] as Map?)?.cast<String, dynamic>(),
              ))
          .toList();

      Map<String, dynamic>? requestSchema;
      final rb = (op['requestBody'] as Map?)?.cast<String, dynamic>();
      final rbContent = (rb?['content'] as Map?)?.cast<String, dynamic>();
      final appJson = (rbContent?['application/json'] as Map?)?.cast<String, dynamic>();
      requestSchema = (appJson?['schema'] as Map?)?.cast<String, dynamic>();

      Map<String, dynamic>? responseSchema;
      final responses = (op['responses'] as Map?)?.cast<String, dynamic>() ?? {};
      final res2xx = responses.entries.firstWhere(
        (e) => e.key.startsWith('2'),
        orElse: () => (const MapEntry('', null)),
      ).value as Map?;
      final resContent = (res2xx?['content'] as Map?)?.cast<String, dynamic>();
      final resAppJson = (resContent?['application/json'] as Map?)?.cast<String, dynamic>();
      responseSchema = (resAppJson?['schema'] as Map?)?.cast<String, dynamic>();

      endpoints.add(ApiEndpoint(
        method: method,
        path: path,
        summary: op['summary']?.toString(),
        operationId: op['operationId']?.toString(),
        tags: tags,
        parameters: params,
        requestBodySchema: requestSchema,
        responseSchema: responseSchema,
      ));
    }
  }
  return endpoints;
}

Future<String?> loadOpenApiServerUrl() async {
  try {
    final raw = await rootBundle.loadString('assets/openapi/openapi.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final servers = json['servers'] as List?;
    if (servers == null || servers.isEmpty) return null;
    final first = servers.first as Map?;
    final url = first?['url']?.toString();
    return url;
  } catch (_) {
    return null;
  }
}
