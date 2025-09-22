import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/models/resume.dart';
import 'package:portfolio/state/resume_state.dart';
import 'package:url_launcher/url_launcher.dart';

class ResumePage extends ConsumerWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;
    final resumeAsync = ref.watch(resumeProvider(localeCode));

    return resumeAsync.when(
      data: (resume) => _ResumeContent(resume: resume, l10n: l10n),
      error: (e, st) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text('Failed to load resume: $e'),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ResumeContent extends StatelessWidget {
  const _ResumeContent({
    required this.resume,
    required this.l10n,
  });

  final Resume resume;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              _HeaderSection(personal: resume.personal, l10n: l10n),
              const SizedBox(height: 32),

              // Summary section
              _SummarySection(summary: resume.personal.summary, l10n: l10n),
              const SizedBox(height: 32),

              // Experience section
              _ExperienceSection(experience: resume.experience, l10n: l10n),
              const SizedBox(height: 32),

              // Skills section
              _SkillsSection(skills: resume.skills, l10n: l10n),
              const SizedBox(height: 32),

              // Education & Certifications row
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 600;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _EducationSection(education: resume.education, l10n: l10n),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _CertificationsSection(certifications: resume.certifications, l10n: l10n),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _EducationSection(education: resume.education, l10n: l10n),
                        const SizedBox(height: 32),
                        _CertificationsSection(certifications: resume.certifications, l10n: l10n),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 32),

              // Project highlights
              _ProjectHighlightsSection(projects: resume.projectsHighlight, l10n: l10n),
              const SizedBox(height: 32),

              // Languages & Interests row
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 600;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _LanguagesSection(languages: resume.languages, l10n: l10n),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _InterestsSection(interests: resume.interests, l10n: l10n),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _LanguagesSection(languages: resume.languages, l10n: l10n),
                        const SizedBox(height: 32),
                        _InterestsSection(interests: resume.interests, l10n: l10n),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({
    required this.personal,
    required this.l10n,
  });

  final PersonalInfo personal;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                personal.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${personal.title} • ${personal.location}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _ContactChip(
                    icon: Icons.email,
                    label: personal.email,
                    onTap: () => launchUrl(Uri.parse('mailto:${personal.email}')),
                  ),
                  _ContactChip(
                    icon: Icons.code,
                    label: 'GitHub',
                    onTap: () => launchUrl(Uri.parse(personal.github)),
                  ),
                  _ContactChip(
                    icon: Icons.business,
                    label: 'LinkedIn',
                    onTap: () => launchUrl(Uri.parse(personal.linkedin)),
                  ),
                  _ContactChip(
                    icon: Icons.picture_as_pdf,
                    label: l10n.commonDownloadResume,
                    onTap: () => launchUrl(Uri.parse('resume.pdf')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  const _ContactChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({
    required this.summary,
    required this.l10n,
  });

  final String summary;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: l10n.resumeSummaryTitle,
      icon: Icons.person,
      child: Text(
        summary,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
      ),
    );
  }
}

class _ExperienceSection extends StatelessWidget {
  const _ExperienceSection({
    required this.experience,
    required this.l10n,
  });

  final List<Experience> experience;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: l10n.resumeExperienceTitle,
      icon: Icons.work,
      child: Column(
        children: experience.asMap().entries.map((entry) {
          final index = entry.key;
          final exp = entry.value;
          return Column(
            children: [
              _ExperienceItem(experience: exp),
              if (index < experience.length - 1) ...[
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _ExperienceItem extends StatelessWidget {
  const _ExperienceItem({required this.experience});

  final Experience experience;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company and position
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    experience.position,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    experience.company,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  experience.period,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  experience.location,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Description
        Text(
          experience.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 12),

        // Achievements
        ...experience.achievements.map((achievement) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      achievement,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 12),

        // Technologies
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: experience.technologies.map((tech) => Chip(
                label: Text(tech),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              )).toList(),
        ),
      ],
    );
  }
}

class _SkillsSection extends StatelessWidget {
  const _SkillsSection({
    required this.skills,
    required this.l10n,
  });

  final Skills skills;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: l10n.resumeSkillsTitle,
      icon: Icons.code,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkillCategory(
            title: l10n.resumeSkillsProgramming,
            skills: skills.programmingLanguages,
          ),
          const SizedBox(height: 16),
          _SkillCategory(
            title: l10n.resumeSkillsBackend,
            skills: skills.backendTechnologies,
          ),
          const SizedBox(height: 16),
          _SkillCategory(
            title: l10n.resumeSkillsInfrastructure,
            skills: skills.infrastructure,
          ),
          const SizedBox(height: 16),
          _SkillCategory(
            title: l10n.resumeSkillsData,
            skills: skills.dataProcessing,
          ),
        ],
      ),
    );
  }
}

class _SkillCategory extends StatelessWidget {
  const _SkillCategory({
    required this.title,
    required this.skills,
  });

  final String title;
  final Map<String, List<String>> skills;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...skills.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key.replaceAll('_', ' ').toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: entry.value.map((skill) => Chip(
                          label: Text(skill),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        )).toList(),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

class _EducationSection extends StatelessWidget {
  const _EducationSection({
    required this.education,
    required this.l10n,
  });

  final List<Education> education;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: l10n.resumeEducationTitle,
      icon: Icons.school,
      child: Column(
        children: education.map((edu) => _EducationItem(education: edu)).toList(),
      ),
    );
  }
}

class _EducationItem extends StatelessWidget {
  const _EducationItem({required this.education});

  final Education education;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          education.degree,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          education.school,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${education.period} • ${education.location}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        if (education.achievements.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...education.achievements.map((achievement) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(achievement)),
                  ],
                ),
              )),
        ],
      ],
    );
  }
}

class _CertificationsSection extends StatelessWidget {
  const _CertificationsSection({
    required this.certifications,
    required this.l10n,
  });

  final List<Certification> certifications;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: l10n.resumeCertificationsTitle,
      icon: Icons.verified,
      child: Column(
        children: certifications.map((cert) => _CertificationItem(certification: cert)).toList(),
      ),
    );
  }
}

class _CertificationItem extends StatelessWidget {
  const _CertificationItem({required this.certification});

  final Certification certification;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            certification.name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            certification.issuer,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            certification.date,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectHighlightsSection extends StatelessWidget {
  const _ProjectHighlightsSection({
    required this.projects,
    required this.l10n,
  });

  final List<ProjectHighlight> projects;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: l10n.resumeProjectsTitle,
      icon: Icons.star,
      child: Column(
        children: projects.asMap().entries.map((entry) {
          final index = entry.key;
          final project = entry.value;
          return Column(
            children: [
              _ProjectHighlightItem(project: project),
              if (index < projects.length - 1) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _ProjectHighlightItem extends StatelessWidget {
  const _ProjectHighlightItem({required this.project});

  final ProjectHighlight project;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          project.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          project.description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.trending_up,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  project.impact,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: project.technologies.map((tech) => Chip(
                label: Text(tech),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              )).toList(),
        ),
      ],
    );
  }
}

class _LanguagesSection extends StatelessWidget {
  const _LanguagesSection({
    required this.languages,
    required this.l10n,
  });

  final List<Language> languages;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: l10n.resumeLanguagesTitle,
      icon: Icons.language,
      child: Column(
        children: languages.map((lang) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lang.language,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    lang.level,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )).toList(),
      ),
    );
  }
}

class _InterestsSection extends StatelessWidget {
  const _InterestsSection({
    required this.interests,
    required this.l10n,
  });

  final List<String> interests;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: l10n.resumeInterestsTitle,
      icon: Icons.favorite,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: interests.map((interest) => Chip(
              label: Text(interest),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            )).toList(),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
