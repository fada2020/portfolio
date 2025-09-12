import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/models/openapi.dart';
import 'package:portfolio/utils/curl_builder.dart';

void main() {
  ApiEndpoint _ep({String method = 'GET', String path = '/v1/things/{id}', List<ApiParameter> params = const [], Map<String, dynamic>? req}) {
    return ApiEndpoint(
      method: method,
      path: path,
      parameters: params,
      requestBodySchema: req,
    );
  }

  test('buildCurl replaces path params and adds required query', () {
    final e = _ep(params: [
      ApiParameter(name: 'id', location: 'path', required: true, schema: const {'type': 'string'}),
      ApiParameter(name: 'limit', location: 'query', required: true, schema: const {'type': 'integer', 'default': 10}),
      ApiParameter(name: 'q', location: 'query', required: false, schema: const {'type': 'string'}),
    ]);
    final curl = buildCurl(e, 'https://api.example.com');
    expect(curl.contains("/v1/things/value?limit=10"), true);
  });

  test('buildCurl adds auth header and body', () {
    final e = _ep(method: 'POST', req: const {
      'type': 'object',
      'properties': {'name': {'type': 'string'}},
      'required': ['name']
    });
    final curl = buildCurl(e, 'https://api.example.com', includeAuth: true, token: 'token123');
    expect(curl.contains("-H 'authorization: Bearer token123'"), true);
    expect(curl.contains("-d '{\"name\":"), true);
  });
}

