class Project {
  const Project({
    required this.id,
    required this.title,
    required this.period,
    required this.stack,
    this.domains = const [],
    required this.role,
    required this.summary,
    this.body,
    this.metrics,
    this.repo,
    this.demo,
  });

  factory Project.fromMap(Map<dynamic, dynamic> m) {
    Uri? parseUri(dynamic v) => v == null ? null : Uri.tryParse(v.toString());
    return Project(
      id: m['id'] as String,
      title: m['title'] as String,
      period: m['period'] as String? ?? '',
      stack: (m['stack'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      domains: (m['domains'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      role: m['role'] as String? ?? '',
      summary: m['summary'] as String? ?? '',
      body: m['body'] as String?,
      metrics: (m['metrics'] as Map?)?.map((k, v) => MapEntry(k.toString(), num.tryParse(v.toString()) ?? 0)),
      repo: parseUri(m['links']?['repo']),
      demo: parseUri(m['links']?['demo']),
    );
  }

  final String id;
  final String title;
  final String period;
  final List<String> stack;
  final List<String> domains;
  final String role;
  final Map<String, num>? metrics;
  final String summary;
  final String? body; // path to markdown file relative to locale folder
  final Uri? repo;
  final Uri? demo;
}
