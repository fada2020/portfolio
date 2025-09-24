# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter Web portfolio application for a backend developer, built with Riverpod for state management, internationalization (i18n) support for English and Korean, and deployed to GitHub Pages. The app showcases projects, blog posts, API documentation, and professional information.

## Common Development Commands

### Flutter Commands
```bash
# Run the app in development mode
flutter run -d chrome

# Build for web production (with proper base href for GitHub Pages)
flutter build web --base-href /<REPO_NAME>/

# Build for local preview (no base href needed)
flutter build web

# Run tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/specific_test.dart

# Analyze code for issues (matches CI/CD pipeline)
flutter analyze --no-fatal-infos --no-fatal-warnings

# Format code (run before committing)
dart format .

# Get dependencies
flutter pub get

# Clean build artifacts
flutter clean
```

### Localization
```bash
# Generate localization files (run after modifying l10n/app_en.arb or app_ko.arb)
flutter gen-l10n
```

### Deployment
```bash
# Generate sitemap and robots.txt for production
dart run tool/sitemap.dart --out build/web
```

## Architecture Overview

### Core Architecture Patterns
- **State Management**: Flutter Riverpod with providers for global state
- **Navigation**: GoRouter with shell routes for consistent app structure
- **Internationalization**: Flutter's built-in l10n with English/Korean support, locale persistence via localStorage, URL override support (?lang=en|ko)
- **Content Management**: YAML/Markdown content pipeline in `assets/contents/` with structured folders for bilingual content
- **OpenAPI Integration**: Interactive API explorer with cURL generation and mock response toggle

### Project Structure
```
lib/
├── main.dart                    # App entry point with ProviderScope
├── router.dart                  # GoRouter configuration with all routes
├── l10n/                       # Generated localization files
├── models/                     # Data models (Project, Post, Profile, OpenAPI)
├── state/                      # Riverpod providers and state management
├── services/                   # Business logic and data loading
├── features/                   # Feature-based organization
│   ├── common/
│   │   └── widgets/app_shell.dart  # Main app layout with navigation
│   ├── home/                   # Home page
│   ├── projects/               # Projects listing and detail pages
│   ├── blog/                   # Blog listing and detail pages
│   ├── api/                    # API documentation page with OpenAPI explorer
│   ├── resume/                 # Resume/CV page
│   ├── contact/                # Contact information page
│   └── privacy/                # Privacy policy pages
├── utils/                      # Utility functions
assets/
├── contents/{en,ko}/           # Bilingual content (profile, resume, projects, posts)
├── openapi/openapi.json        # Sample OpenAPI specification
test/                           # Unit and widget tests mirroring feature structure
tool/                           # Build tools (sitemap generator)
web/                            # Web-specific assets (index.html, favicons, OG image)
```

### Key State Management Patterns
- **Locale State**: `locale_state.dart` manages language switching with persistence
- **Content Loading**: `content_loader.dart` handles async loading of markdown content
- **OpenAPI State**: `openapi_state.dart` manages API documentation state
- **Projects Filter**: `projects_filter.dart` handles project filtering and search
- All state providers follow Riverpod patterns with proper error handling

### Content Management System
- Content stored as markdown files in `assets/contents/{en,ko}/`
- Structured folders: `posts/`, `projects/`, and root-level content files
- Models parse YAML frontmatter and markdown content
- `ContentLoader` service handles async loading with error states

### Navigation & Routing
- Uses GoRouter with ShellRoute pattern for consistent layout
- AppShell provides responsive navigation (drawer on mobile, tabs on desktop)
- Accessibility features: skip links, focus management, semantic markup
- Language switching via URL parameters (?lang=ko) or UI controls

### Responsive Design Patterns
- Breakpoint at 720px width for mobile/desktop layouts
- Mobile: Drawer navigation with focus management
- Desktop: Horizontal navigation bar with language selector
- AppShell handles all responsive behavior centrally

## Development Guidelines

### State Management
- Use Riverpod providers for all global state
- Follow async patterns with proper error handling
- Use ConsumerWidget/ConsumerStatefulWidget for reactive UI
- Keep state immutable and use copyWith patterns

### Content Files
- Place content in appropriate language folder: `assets/contents/{en,ko}/`
- Use YAML frontmatter for metadata in markdown files
- Project files should include: title, description, tech stack, links
- Blog post files should include: title, date, tags, description

### Internationalization
- Add new strings to `l10n/app_en.arb` and `l10n/app_ko.arb`
- Run `flutter gen-l10n` after adding new localization keys
- Use `AppLocalizations.of(context)!` to access localized strings
- Support both English and Korean throughout the app

### Testing
- Unit tests for utilities, models, and business logic (content loaders, filters)
- Widget tests for complex UI components and state interactions
- Core test coverage: `content_loader_test.dart`, filters, contact forms, API cURL generation
- Mock external dependencies and async operations
- Use `flutter test --coverage` to generate coverage reports in `coverage/lcov.info`

### Code Organization
- Follow feature-based folder structure under `lib/features/`
- Keep models simple with clear data structures
- Separate business logic into service classes
- Use meaningful file and class names that reflect their purpose

### Deployment & CI/CD
- GitHub Actions workflow automatically deploys to GitHub Pages on push to main/master
- Pipeline: analyze → test → build → deploy with smart base-href detection
- SPA fallback: copies `index.html` to `404.html` for client-side routing
- Generates sitemap and robots.txt for SEO using `tool/sitemap.dart`
- Static assets (PDFs, OG images) hosted directly from `web/` directory