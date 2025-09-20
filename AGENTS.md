# Repository Guidelines

## Project Structure & Module Organization
Source code lives under `lib/`, organized by feature folders such as `lib/features/profile/` and shared utilities in `lib/services/` or `lib/utils/`. Widget and unit tests mirror this layout inside `test/`, keeping filenames aligned with the implementation (`profile_view_test.dart`). Static assets are stored under `assets/` and must be declared in `pubspec.yaml`; confirm licensing before adding new media. Platform-specific targets remain in the default Flutter directories (`ios/`, `android/`, `web/`, etc.) and should stay untouched unless platform work is intentional.

## Build, Test, and Development Commands
Use `flutter pub get` to install or refresh dependencies. Run `flutter analyze` to enforce lints before committing. Format Dart code with `dart format .` (2-space indent). For quick local runs, execute `flutter run -d chrome`. Validate logic and widgets with `flutter test`; generate coverage via `flutter test --coverage`. Production builds rely on `flutter build web` and `flutter build apk --release` when preparing deliverables.

## Coding Style & Naming Conventions
Follow Flutter defaults: 2-space indentation, concise line length, and no tabs. Prefer relative imports within `lib/` to avoid brittle cross-feature references. Name classes in UpperCamelCase, members in lowerCamelCase, and files/folders in lower_snake_case (e.g., `project_detail_widget.dart`). Widgets that represent UI elements should end with `Widget` when clarity improves readability.

## Testing Guidelines
Leverage `flutter_test` with `package:mocktail` or similar for isolation. Place tests beside their feature counterparts (`test/features/...`). Name test files with the `_test.dart` suffix and write deterministic expectations. Aim for meaningful coverage, especially around core services and widgets; review the generated `coverage/lcov.info` when running coverage locally.

## Commit & Pull Request Guidelines
Use Conventional Commits (`feat:`, `fix:`, `chore:`) in imperative mood. PRs should describe scope, link relevant issues, and include before/after screenshots for UI changes. Ensure CI prerequisites—`flutter analyze`, `dart format .`, and `flutter test`—are green before requesting review. Mention configuration or migration notes directly in the PR body when applicable.

## Security & Configuration Tips
Never commit secrets. Inject environment-specific values using `--dart-define` or configuration files excluded from source control. Keep asset references synced with `pubspec.yaml`, and validate third-party licenses prior to inclusion.
