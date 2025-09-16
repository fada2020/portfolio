## Content Pipeline (YAML/Markdown)

Content is managed as flat files:

- YAML indices: projects.yaml, posts.yaml, profile.yaml
- Markdown bodies under locale folders
- Lightweight loaders parse YAML/MD at runtime and bind to widgets

Benefits: versioned content, simple authoring, and deterministic rendering with tests.

