class Profile {
  final String name;
  final String title;
  final String location;
  final List<String> summary;
  final Map<String, String> links; // email, github, linkedin, resume_url
  final Map<String, List<String>> skills; // primary/secondary/exposure/learning

  const Profile({
    required this.name,
    required this.title,
    required this.location,
    required this.summary,
    required this.links,
    this.skills = const {},
  });

  factory Profile.fromMap(Map<dynamic, dynamic> m) => Profile(
        name: (m['name'] ?? '').toString(),
        title: (m['title'] ?? '').toString(),
        location: (m['location'] ?? '').toString(),
        summary: ((m['summary'] as List?) ?? const []).map((e) => e.toString()).toList(),
        links: ((m['links'] as Map?) ?? const {}).map((k, v) => MapEntry(k.toString(), v.toString())),
        skills: ((m['skills'] as Map?) ?? const {})
            .map((k, v) => MapEntry(k.toString(), (v as List?)?.map((e) => e.toString()).toList() ?? const [])),
      );
}
