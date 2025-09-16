class ApiEndpoint {
  ApiEndpoint({
    required this.method,
    required this.path,
    this.summary,
    this.operationId,
    this.tags = const [],
    this.parameters = const [],
    this.requestBodySchema,
    this.responseSchema,
  });

  final String method; // GET/POST/...
  final String path;
  final String? summary;
  final String? operationId;
  final List<String> tags;
  final List<ApiParameter> parameters;
  final Map<String, dynamic>? requestBodySchema;
  final Map<String, dynamic>? responseSchema; // pick first 2xx JSON schema if any
}

class ApiParameter {
  ApiParameter({required this.name, required this.location, required this.required, this.schema});

  final String name;
  final String location; // query, path, header
  final bool required;
  final Map<String, dynamic>? schema;
}
