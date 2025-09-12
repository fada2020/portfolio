import 'dart:convert';
import 'package:portfolio/models/openapi.dart';
import 'package:portfolio/utils/json_schema_sample.dart';

String buildCurl(
  ApiEndpoint e,
  String baseUrl, {
  bool includeAuth = false,
  String token = '',
  Map<String, dynamic>? components,
}) {
  String path = e.path;
  for (final p in e.parameters.where((p) => p.location == 'path')) {
    final placeholder = (p.schema?['type'] == 'integer' || p.schema?['type'] == 'number') ? '1' : 'value';
    path = path.replaceAll('{${p.name}}', placeholder);
  }
  final qp = <String, String>{};
  for (final p in e.parameters.where((p) => p.location == 'query')) {
    final sch = p.schema ?? {};
    final val = sch['default'] ?? (sch['type'] == 'integer' || sch['type'] == 'number' ? 0 : 'value');
    if (p.required) qp[p.name] = '$val';
  }
  final query = qp.isEmpty ? '' : '?' + qp.entries.map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}').join('&');
  final uri = baseUrl.replaceAll(RegExp(r'/+$'), '') + path + query;
  final parts = ["curl -X ${e.method} '$uri'", "-H 'accept: application/json'"];
  if (includeAuth && token.isNotEmpty) {
    parts.add("-H 'authorization: Bearer ${token.replaceAll("'", "\'")}'");
  }
  if (e.requestBodySchema != null && e.method != 'GET') {
    final body = components == null
        ? sampleFromSchema(e.requestBodySchema)
        : sampleFromSchemaWithComponents(e.requestBodySchema, components);
    parts.add("-H 'content-type: application/json'");
    parts.add("-d '${jsonEncode(body)}'");
  }
  // Keep single-line for portability in terminals/editors.
  return parts.join(' ');
}

