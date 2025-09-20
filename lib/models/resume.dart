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
      personal: PersonalInfo.fromMap(map['personal'] ?? {}),
      experience: (map['experience'] as List<dynamic>?)
          ?.map((e) => Experience.fromMap(e as Map<String, dynamic>))
          .toList() ?? [],
      education: (map['education'] as List<dynamic>?)
          ?.map((e) => Education.fromMap(e as Map<String, dynamic>))
          .toList() ?? [],
      skills: Skills.fromMap(map['skills'] ?? {}),
      certifications: (map['certifications'] as List<dynamic>?)
          ?.map((e) => Certification.fromMap(e as Map<String, dynamic>))
          .toList() ?? [],
      projectsHighlight: (map['projects_highlight'] as List<dynamic>?)
          ?.map((e) => ProjectHighlight.fromMap(e as Map<String, dynamic>))
          .toList() ?? [],
      languages: (map['languages'] as List<dynamic>?)
          ?.map((e) => Language.fromMap(e as Map<String, dynamic>))
          .toList() ?? [],
      interests: (map['interests'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
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
      name: map['name'] ?? '',
      title: map['title'] ?? '',
      location: map['location'] ?? '',
      email: map['email'] ?? '',
      github: map['github'] ?? '',
      linkedin: map['linkedin'] ?? '',
      summary: map['summary'] ?? '',
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
      company: map['company'] ?? '',
      position: map['position'] ?? '',
      period: map['period'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      achievements: (map['achievements'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      technologies: (map['technologies'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
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
      degree: map['degree'] ?? '',
      school: map['school'] ?? '',
      period: map['period'] ?? '',
      location: map['location'] ?? '',
      achievements: (map['achievements'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
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
      name: map['name'] ?? '',
      issuer: map['issuer'] ?? '',
      date: map['date'] ?? '',
      credentialId: map['credential_id'] ?? '',
    );
  }
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
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      impact: map['impact'] ?? '',
      technologies: (map['technologies'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
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
      language: map['language'] ?? '',
      level: map['level'] ?? '',
    );
  }
}