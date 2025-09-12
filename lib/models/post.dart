class PostMeta {
  final String id;
  final String title;
  final DateTime date;
  final List<String> tags;
  final String body; // relative path under locale folder

  const PostMeta({
    required this.id,
    required this.title,
    required this.date,
    required this.tags,
    required this.body,
  });

  factory PostMeta.fromMap(Map<dynamic, dynamic> m) {
    final dateStr = (m['date'] ?? '').toString();
    final dt = DateTime.tryParse(dateStr) ?? DateTime.fromMillisecondsSinceEpoch(0);
    return PostMeta(
      id: m['id'] as String,
      title: m['title'] as String,
      date: dt,
      tags: (m['tags'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      body: m['body'] as String,
    );
  }
}

