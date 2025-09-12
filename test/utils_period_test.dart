import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/utils/period.dart';

void main() {
  group('periodStartKey', () {
    test('parses en dash range', () {
      expect(periodStartKey('2023.01–2023.09'), 202301);
    });

    test('parses hyphen range', () {
      expect(periodStartKey('2023.12-2024.01'), 202312);
    });

    test('handles single year.month', () {
      expect(periodStartKey('2022.07'), 202207);
    });

    test('invalid returns 0', () {
      expect(periodStartKey('unknown'), 0);
    });
  });
}

