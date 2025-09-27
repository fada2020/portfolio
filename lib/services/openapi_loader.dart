import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:portfolio/models/openapi.dart';

// List of available OpenAPI specifications
const apiSpecs = [
  'assets/openapi/portfolio-api.json',  // Portfolio Backend API
];

Future<Map<String, dynamic>> loadOpenApiSpec([String? specPath]) async {
  final path = specPath ?? apiSpecs.first;
  final raw = await rootBundle.loadString(path);
  return jsonDecode(raw) as Map<String, dynamic>;
}

Future<List<Map<String, dynamic>>> loadAllOpenApiSpecs() async {
  final specs = <Map<String, dynamic>>[];
  for (final specPath in apiSpecs) {
    try {
      final spec = await loadOpenApiSpec(specPath);
      // Add metadata to identify the spec
      spec['_specPath'] = specPath;
      spec['_specName'] = _getSpecName(specPath);
      specs.add(spec);
    } catch (e) {
      print('Failed to load OpenAPI spec $specPath: $e');
    }
  }
  return specs;
}

String _getSpecName(String path) {
  if (path.contains('portfolio-api')) return 'Portfolio API';
  return 'API';
}

Future<List<ApiEndpoint>> loadOpenApi([String? specPath]) async {
  final json = await loadOpenApiSpec(specPath);
  return _parseEndpoints(json);
}

Future<List<ApiEndpoint>> loadAllOpenApiEndpoints() async {
  final allSpecs = await loadAllOpenApiSpecs();
  final allEndpoints = <ApiEndpoint>[];

  for (final spec in allSpecs) {
    final endpoints = _parseEndpoints(spec);
    // Add API source information to each endpoint
    final specName = spec['_specName'] as String? ?? 'Unknown API';
    final baseUrl = _getBaseUrl(spec);

    for (final endpoint in endpoints) {
      final updatedEndpoint = ApiEndpoint(
        method: endpoint.method,
        path: endpoint.path,
        summary: '[$specName] ${endpoint.summary ?? ''}',
        operationId: endpoint.operationId,
        tags: [...endpoint.tags, specName],
        parameters: endpoint.parameters,
        requestBodySchema: endpoint.requestBodySchema,
        responseSchema: endpoint.responseSchema,
      );
      allEndpoints.add(updatedEndpoint);
    }
  }

  return allEndpoints;
}

List<ApiEndpoint> _parseEndpoints(Map<String, dynamic> json) {
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

String _getBaseUrl(Map<String, dynamic> spec) {
  final host = spec['host'] as String?;
  final basePath = spec['basePath'] as String? ?? '';
  final schemes = spec['schemes'] as List?;
  final scheme = schemes?.first as String? ?? 'https';

  if (host != null) {
    return '$scheme://$host$basePath';
  }

  // Fallback to servers array (OpenAPI 3.0+)
  final servers = spec['servers'] as List?;
  if (servers != null && servers.isNotEmpty) {
    final server = servers.first as Map?;
    return server?['url'] as String? ?? '';
  }

  return 'http://localhost:8080';
}

Future<String?> loadOpenApiServerUrl() async {
  try {
    final raw = await rootBundle.loadString('assets/openapi/portfolio-api.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;

    // Check for OpenAPI 3.0+ servers array first
    final servers = json['servers'] as List?;
    if (servers != null && servers.isNotEmpty) {
      final first = servers.first as Map?;
      final url = first?['url']?.toString();
      if (url != null) return url;
    }

    // Fallback to Swagger 2.0 format
    final host = json['host'] as String?;
    final basePath = json['basePath'] as String? ?? '';
    final schemes = json['schemes'] as List?;
    final scheme = schemes?.first as String? ?? 'https';

    if (host != null) {
      return '$scheme://$host$basePath';
    }

    return null;
  } catch (_) {
    return null;
  }
}
