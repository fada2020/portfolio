# Why Riverpod for Flutter Web

- Decoupled from BuildContext; easier testing.
- Fine-grained providers; rebuild only what changes.
- Async patterns fit content loading and caching.

## Patterns
- Use FutureProvider for content, StateNotifier for filters.
- Co-locate providers per feature.

## Example
```dart
final projectsProvider = FutureProvider((ref) async => loadProjects('en'));
```
