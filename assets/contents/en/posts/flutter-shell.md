# Unifying Our Mobile Experience with Flutter WebView

In mid-2024 marketing asked for “one mobile app” that combined every learning service—Hybricks, Quest, SuperBuddies, and YongClass. Native rewrites were impossible, so we built a Flutter WebView shell that ships our web apps with a native feel.

## Why a shell?

- We already owned responsive web versions for each service.
- App store presence mattered more than offline capability.
- Release date: one month.

Flutter gave us a single codebase, hot reload for quick tweaks, and enough control to expose native hooks (deep links, file pickers) when required.

## Architecture overview

```dart
class ShellApp extends StatefulWidget { ... }

class _ShellAppState extends State<ShellApp> {
  final _tabs = const [
    WebTab(title: 'Hybricks', url: 'https://hybricks.example.com'),
    WebTab(title: 'Quest', url: 'https://quest.example.com'),
    WebTab(title: 'SuperBuddies', url: 'https://super.example.com'),
    WebTab(title: 'YongClass', url: 'https://yong.example.com'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebShell(tabs: _tabs),
    );
  }
}
```

Each tab wraps a [`WebViewController`](https://api.flutter.dev/flutter/webview_flutter/WebViewController-class.html). We injected a minimal JavaScript bridge so web apps can trigger native actions (open in-app browser, copy text, share links).

## Deployment checklist

1. **Deep link router:** Flutter routes `/deeplink?target=quest#/courses/123` to the correct tab and path.
2. **Unified auth cookie:** We centralised login via an SSO endpoint, then synchronised cookies into WebViews at startup.
3. **Caching policy:** Service workers handle static caching; the shell only caches top-level navigation state.
4. **CI/CD:** GitHub Actions bundles the Flutter shell, runs integration tests on Firebase Test Lab, and uploads builds to the Play Store and Galaxy Store.

## Results

- Delivered in 4 weeks with two engineers.
- Support tickets about “Which app do I download?” dropped to zero.
- Marketing campaigns now link to a single store entry with a deep link parameter.

The most important lesson: a WebView shell is still a product. We maintain a backlog for bridge features, observability, and store updates—treating it with the same care as our backend services.
