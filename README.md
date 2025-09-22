# Full-stack Portfolio (Flutter)

A bilingual portfolio built with Flutter Web to showcase full-stack case studies—Spring Boot migrations, shared platform design, and Flutter DX improvements. It ships with internationalized content, Markdown/YAML powered data pipelines, and an interactive OpenAPI explorer.

## Highlights
- **KO/EN internationalization** with locale persistence, query overrides (`?lang=`), and fully localized UI copy.
- **Structured content pipeline**: projects, posts, and resume data stored as YAML/Markdown for easy editing and translation.
- **OpenAPI showcase**: load endpoints from `assets/openapi/openapi.json`, filter/search, generate authenticated cURL snippets, and toggle mock responses.
- **SEO & social**: tailored meta tags (`web/index.html`), shareable OG/Twitter card (`web/og-image.png`), and accessibility-friendly navigation.
- **Quality gates**: unit/widget tests for loaders, filters, widgets, plus CI/CD workflow that analyzes, tests, builds, and deploys to GitHub Pages.

## Getting Started
```bash
flutter pub get          # install dependencies
dart format .            # format before committing
flutter analyze          # static analysis
flutter test             # run unit/widget tests
flutter run -d chrome    # local web preview
```

### Project Layout
| Path | Description |
| --- | --- |
| `lib/` | Flutter application code organized by feature folder (home, projects, blog, api, resume, etc.). |
| `lib/state/` | Riverpod providers/state notifiers for content, filters, and search. |
| `lib/services/` | Content loaders (YAML/Markdown), locale persistence, and utilities. |
| `assets/contents/{en,ko}/` | Source-of-truth YAML/Markdown for profile, resume, projects, and blog posts. |
| `assets/openapi/openapi.json` | Sample OpenAPI spec consumed by the API explorer. |
| `test/` | Unit/widget tests mirroring the feature structure. |
| `web/` | Web-specific overrides (HTML shell, manifest, favicons, share image, downloadable resumes). |

## Editing Content
- Update profile, resume, projects, and blog metadata under `assets/contents/{en,ko}/`.
- Markdown bodies for projects and posts live in language-specific subfolders (`projects/*.md`, `posts/*.md`).
- When adding new assets (PDFs, images), declare them in `pubspec.yaml` or place them under `web/` for static hosting.

## Localization
- Strings are managed via `lib/l10n/app_*.arb`. Run `flutter gen-l10n` after adding keys.
- The locale is remembered via `localStorage` on web and can be overridden with `?lang=en|ko`.

## Testing & QA
- Core coverage is provided by loaders (`content_loader_test.dart`), filters, contact form widget tests, and API cURL generation.
- Add additional widget tests for new routes or async flows inside `test/features/...`.
- Use `flutter test --coverage` to generate `coverage/lcov.info` for reporting.

## Deployment
- GitHub Actions workflow (see `.github/workflows/`) runs `flutter analyze`, `flutter test`, `flutter build web --release --pwa-strategy=none`, and deploys to GitHub Pages. *(The previous `flutter build web --release` command remains commented in the workflow for reference.)*
- To build locally with your repository slug: `flutter build web --release --pwa-strategy=none --base-href /<REPO_NAME>/`.
- Static assets like `web/resume.pdf` and `web/og-image.png` ship with the build for direct hosting.

## Next Steps
- Fill in real project case studies and blog posts under `assets/contents/`.
- Replace the placeholder OG image (`web/og-image.png`) with a branded design.
- Capture and add screenshots (e.g., `docs/screenshots/home.png`) for README visuals.
