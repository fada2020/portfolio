class Resume {
  final PersonalInfo personal;
  final List<Experience> experience;
  final List<Education> education;
  final Skills skills;
  final List<Certification> certifications;
  final List<ProjectHighlight> projectsHighlight;
  final List<Language> languages;
  final List<String> interests;

  Resume({
    required this.personal,
    required this.experience,
    required this.education,
    required this.skills,
    required this.certifications,
    required this.projectsHighlight,
    required this.languages,
    required this.interests,
  });

  factory Resume.fromMap(Map<String, dynamic> map) {
    return Resume(
      personal: PersonalInfo.fromMap(_asMap(map['personal'])),
      experience: _asMapList(map['experience'])
          .map(Experience.fromMap)
          .toList(),
      education: _asMapList(map['education'])
          .map(Education.fromMap)
          .toList(),
      skills: Skills.fromMap(_asMap(map['skills'])),
      certifications: _asMapList(map['certifications'])
          .map(Certification.fromMap)
          .toList(),
      projectsHighlight: _asMapList(map['projects_highlight'])
          .map(ProjectHighlight.fromMap)
          .toList(),
      languages: _asMapList(map['languages'])
          .map(Language.fromMap)
          .toList(),
      interests: _asStringList(map['interests']),
    );
  }
}

class PersonalInfo {
  final String name;
  final String title;
  final String location;
  final String email;
  final String github;
  final String linkedin;
  final String summary;

  PersonalInfo({
    required this.name,
    required this.title,
    required this.location,
    required this.email,
    required this.github,
    required this.linkedin,
    required this.summary,
  });

  factory PersonalInfo.fromMap(Map<String, dynamic> map) {
    return PersonalInfo(
      name: _asString(map['name']),
      title: _asString(map['title']),
      location: _asString(map['location']),
      email: _asString(map['email']),
      github: _asString(map['github']),
      linkedin: _asString(map['linkedin']),
      summary: _asString(map['summary']),
    );
  }
}

class Experience {
  final String company;
  final String position;
  final String period;
  final String location;
  final String description;
  final List<String> achievements;
  final List<String> technologies;

  Experience({
    required this.company,
    required this.position,
    required this.period,
    required this.location,
    required this.description,
    required this.achievements,
    required this.technologies,
  });

  factory Experience.fromMap(Map<String, dynamic> map) {
    return Experience(
      company: _asString(map['company']),
      position: _asString(map['position']),
      period: _asString(map['period']),
      location: _asString(map['location']),
      description: _asString(map['description']),
      achievements: _asStringList(map['achievements']),
      technologies: _asStringList(map['technologies']),
    );
  }
}

class Education {
  final String degree;
  final String school;
  final String period;
  final String location;
  final List<String> achievements;

  Education({
    required this.degree,
    required this.school,
    required this.period,
    required this.location,
    required this.achievements,
  });

  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      degree: _asString(map['degree']),
      school: _asString(map['school']),
      period: _asString(map['period']),
      location: _asString(map['location']),
      achievements: _asStringList(map['achievements']),
    );
  }
}

class Skills {
  final Map<String, List<String>> programmingLanguages;
  final Map<String, List<String>> backendTechnologies;
  final Map<String, List<String>> infrastructure;
  final Map<String, List<String>> dataProcessing;

  Skills({
    required this.programmingLanguages,
    required this.backendTechnologies,
    required this.infrastructure,
    required this.dataProcessing,
  });

  factory Skills.fromMap(Map<String, dynamic> map) {
    return Skills(
      programmingLanguages: _parseSkillsMap(map['programming_languages']),
      backendTechnologies: _parseSkillsMap(map['backend_technologies']),
      infrastructure: _parseSkillsMap(map['infrastructure']),
      dataProcessing: _parseSkillsMap(map['data_processing']),
    );
  }

  static Map<String, List<String>> _parseSkillsMap(dynamic data) {
    if (data is! Map<String, dynamic>) return {};

    return data.map((key, value) {
      if (value is List<dynamic>) {
        return MapEntry(key, value.map((e) => e.toString()).toList());
      }
      return MapEntry(key, <String>[]);
    });
  }
}

class Certification {
  final String name;
  final String issuer;
  final String date;
  final String credentialId;

  Certification({
    required this.name,
    required this.issuer,
    required this.date,
    required this.credentialId,
  });

  factory Certification.fromMap(Map<String, dynamic> map) {
    return Certification(
      name: _asString(map['name']),
      issuer: _asString(map['issuer']),
      date: _asString(map['date']),
      credentialId: _asString(map['credential_id']),
    );
  }
}

String _asString(dynamic value) => value?.toString() ?? '';

List<String> _asStringList(dynamic data) {
  if (data is! List) return const [];
  return data.map((e) => e.toString()).toList();
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map) {
    return value.map((key, v) => MapEntry(key.toString(), v));
  }
  return <String, dynamic>{};
}

List<Map<String, dynamic>> _asMapList(dynamic value) {
  if (value is! List) return <Map<String, dynamic>>[];
  return value.map(_asMap).toList();
}

class ProjectHighlight {
  final String title;
  final String description;
  final String impact;
  final List<String> technologies;

  ProjectHighlight({
    required this.title,
    required this.description,
    required this.impact,
    required this.technologies,
  });

  factory ProjectHighlight.fromMap(Map<String, dynamic> map) {
    return ProjectHighlight(
      title: _asString(map['title']),
      description: _asString(map['description']),
      impact: _asString(map['impact']),
      technologies: _asStringList(map['technologies']),
    );
  }
}

class Language {
  final String language;
  final String level;

  Language({
    required this.language,
    required this.level,
  });

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      language: _asString(map['language']),
      level: _asString(map['level']),
    );
  }
}
