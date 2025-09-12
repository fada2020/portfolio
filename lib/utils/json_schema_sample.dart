dynamic sampleFromSchema(Map<String, dynamic>? schema, {int depth = 0}) {
  if (schema == null) return null;
  if (depth > 3) return null; // prevent deep recursion

  if (schema.containsKey('example')) return schema['example'];
  if (schema.containsKey('default')) return schema['default'];
  if (schema.containsKey('enum')) {
    final e = schema['enum'];
    if (e is List && e.isNotEmpty) return e.first;
  }

  final type = schema['type'];
  if (type == 'object' || schema.containsKey('properties')) {
    final props = (schema['properties'] as Map?)?.cast<String, dynamic>() ?? {};
    final required = ((schema['required'] as List?)?.map((e) => e.toString()).toSet()) ?? <String>{};
    final out = <String, dynamic>{};
    for (final entry in props.entries) {
      final key = entry.key;
      final propSchema = (entry.value as Map?)?.cast<String, dynamic>() ?? {};
      // include required; include optional if small set
      if (required.contains(key) || out.length < 4) {
        out[key] = sampleFromSchema(propSchema, depth: depth + 1);
      }
    }
    return out;
  }

  if (type == 'array' || schema.containsKey('items')) {
    final items = (schema['items'] as Map?)?.cast<String, dynamic>();
    return [sampleFromSchema(items, depth: depth + 1)];
  }

  switch (type) {
    case 'integer':
    case 'number':
      return 0;
    case 'boolean':
      return false;
    case 'string':
    default:
      final format = schema['format'];
      if (format == 'date-time') return '2024-01-01T00:00:00Z';
      if (format == 'date') return '2024-01-01';
      if (format == 'uuid') return '00000000-0000-0000-0000-000000000000';
      return 'string';
  }
}

Map<String, dynamic> _deref(Map<String, dynamic> schema, Map<String, dynamic> components) {
  if (schema.containsKey(r'$ref')) {
    final ref = schema[r'$ref']?.toString() ?? '';
    if (ref.startsWith('#/components/schemas/')) {
      final key = ref.split('/').last;
      final resolved = ((components['schemas'] as Map?)?[key] as Map?)?.cast<String, dynamic>();
      if (resolved != null) return resolved;
    }
  }
  return schema;
}

Map<String, dynamic> _mergeAllOf(List list) {
  final out = <String, dynamic>{};
  final props = <String, dynamic>{};
  final req = <String>{};
  for (final e in list) {
    if (e is Map) {
      final m = e.cast<String, dynamic>();
      if (m['properties'] is Map) {
        props.addAll((m['properties'] as Map).cast<String, dynamic>());
      }
      if (m['required'] is List) {
        req.addAll((m['required'] as List).map((e) => e.toString()));
      }
    }
  }
  if (props.isNotEmpty) out['properties'] = props;
  if (req.isNotEmpty) out['required'] = req.toList();
  out['type'] = 'object';
  return out;
}

dynamic sampleFromSchemaWithComponents(Map<String, dynamic>? schema, Map<String, dynamic> components, {int depth = 0}) {
  if (schema == null) return null;
  if (depth > 4) return null;

  // Resolve $ref
  if (schema.containsKey(r'$ref')) {
    final resolved = _deref(schema, components);
    if (!identical(resolved, schema)) {
      return sampleFromSchemaWithComponents(resolved, components, depth: depth + 1);
    }
  }

  // oneOf/anyOf: pick first
  for (final key in const ['oneOf', 'anyOf']) {
    if (schema[key] is List && (schema[key] as List).isNotEmpty) {
      final first = (schema[key] as List).first;
      if (first is Map) {
        return sampleFromSchemaWithComponents(first.cast<String, dynamic>(), components, depth: depth + 1);
      }
    }
  }

  // allOf: merge properties/required
  if (schema['allOf'] is List) {
    final merged = _mergeAllOf(schema['allOf'] as List);
    return sampleFromSchemaWithComponents(merged, components, depth: depth + 1);
  }

  // Fallback to simple generator
  return sampleFromSchema(schema, depth: depth + 1);
}

