import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/state/projects_filter.dart';
import 'package:portfolio/utils/period.dart';

void main() {
  test('ProjectsFilterNotifier toggles stacks and domains', () {
    final notifier = ProjectsFilterNotifier();
    expect(notifier.state.stacks, isEmpty);
    notifier.toggleStack('Dart');
    expect(notifier.state.stacks.contains('Dart'), true);
    notifier.toggleStack('Dart');
    expect(notifier.state.stacks.contains('Dart'), false);

    notifier.toggleDomain('Billing');
    expect(notifier.state.domains.contains('Billing'), true);
    notifier.clear();
    expect(notifier.state.stacks, isEmpty);
    expect(notifier.state.domains, isEmpty);
    expect(notifier.state.sort, ProjectSort.latest);
  });

  test('periodStartKey sorting helper', () {
    final items = ['2023.05–2023.06', '2022.12–2023.01', '2024.01–'];
    items.sort((a, b) => periodStartKey(b).compareTo(periodStartKey(a)));
    expect(items.first, '2024.01–');
  });
}

