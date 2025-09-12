import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/utils/json_schema_sample.dart';

void main() {
  group('sampleFromSchema', () {
    test('object with properties', () {
      final schema = {
        'type': 'object',
        'properties': {
          'name': {'type': 'string'},
          'age': {'type': 'integer'}
        },
        'required': ['name']
      };
      final out = sampleFromSchema(schema) as Map<String, dynamic>;
      expect(out.containsKey('name'), true);
    });

    test('enum uses first value', () {
      final schema = {'type': 'string', 'enum': ['A', 'B']};
      expect(sampleFromSchema(schema), 'A');
    });

    test('date-time format', () {
      final schema = {'type': 'string', 'format': 'date-time'};
      expect(sampleFromSchema(schema), isA<String>());
    });

    test('array of strings', () {
      final schema = {'type': 'array', 'items': {'type': 'string'}};
      final out = sampleFromSchema(schema) as List;
      expect(out.length, 1);
    });
  });

  group('sampleFromSchemaWithComponents', () {
    test('ref resolution', () {
      final components = {
        'schemas': {
          'User': {
            'type': 'object',
            'properties': {'id': {'type': 'string'}},
            'required': ['id']
          }
        }
      };
      final schema = {
        r'$ref': '#/components/schemas/User'
      };
      final out = sampleFromSchemaWithComponents(schema, components) as Map<String, dynamic>;
      expect(out.containsKey('id'), true);
    });

    test('oneOf picks first', () {
      final schema = {
        'oneOf': [
          {'type': 'string'},
          {'type': 'integer'}
        ]
      };
      expect(sampleFromSchemaWithComponents(schema, {}), 'string');
    });

    test('allOf merges', () {
      final schema = {
        'allOf': [
          {
            'type': 'object',
            'properties': {'a': {'type': 'string'}},
            'required': ['a']
          },
          {
            'type': 'object',
            'properties': {'b': {'type': 'integer'}}
          }
        ]
      };
      final out = sampleFromSchemaWithComponents(schema, {}) as Map<String, dynamic>;
      expect(out.containsKey('a'), true);
      expect(out.containsKey('b'), true);
    });
  });
}

