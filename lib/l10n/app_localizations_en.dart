// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Backend Portfolio';

  @override
  String get navHome => 'Home';

  @override
  String get navProjects => 'Projects';

  @override
  String get navApi => 'API';

  @override
  String get navBlog => 'Blog';

  @override
  String get navResume => 'Resume';

  @override
  String get navContact => 'Contact';

  @override
  String get languageKorean => 'Korean';

  @override
  String get languageEnglish => 'English';

  @override
  String get homeFeaturedProjects => 'Featured Projects';

  @override
  String get homeRecentPosts => 'Recent Posts';

  @override
  String get commonViewAll => 'View all';

  @override
  String get commonDownloadResume => 'Download Resume';

  @override
  String get commonBlog => 'Blog';

  @override
  String get commonContact => 'Contact';

  @override
  String get homeNoProjects => 'No projects yet.';

  @override
  String get homeNoPosts => 'No posts yet.';

  @override
  String get errLoadProfile => 'Failed to load profile';

  @override
  String get errLoadProjects => 'Failed to load projects';

  @override
  String get errLoadPosts => 'Failed to load posts';

  @override
  String get projectsFilters => 'Filters';

  @override
  String get projectsStacks => 'Stacks';

  @override
  String get projectsDomains => 'Domains';

  @override
  String get projectsSortLatest => 'Latest';

  @override
  String get projectsSortTitle => 'Title A-Z';

  @override
  String get projectsClear => 'Clear';

  @override
  String get projectsNoMatch => 'No projects match filters.';

  @override
  String get blogSearchTitle => 'Search title';

  @override
  String get commonTag => 'Tag';

  @override
  String get commonAll => 'All';

  @override
  String get errFailedToLoad => 'Failed to load';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get goHome => 'Go Home';

  @override
  String get commonMenu => 'Menu';

  @override
  String get commonLanguage => 'Language';

  @override
  String get skipToContent => 'Skip to content';

  @override
  String get privacyTitle => 'Privacy Policy';

  @override
  String get appPrivacyTitle => 'App Privacy Policy';

  @override
  String get apiSearchHint => 'Search path, summary, operationId';

  @override
  String get apiGroupByTag => 'Group by tag';

  @override
  String get apiIncludeAuth => 'Include Authorization';

  @override
  String get apiAuthToken => 'Bearer token';

  @override
  String get apiUntagged => 'Untagged';

  @override
  String get apiParameters => 'Parameters';

  @override
  String get apiRequestBodyJson => 'Request Body (application/json)';

  @override
  String get apiResponseJson => 'Response (application/json, 2xx)';

  @override
  String get apiCurlTitle => 'cURL';

  @override
  String get apiCopy => 'Copy';

  @override
  String get apiCopiedCurl => 'Copied cURL';

  @override
  String get errLoadSpec => 'Failed to load spec';

  @override
  String get apiTryGet => 'Try (GET)';

  @override
  String get apiTry => 'Try';

  @override
  String get apiExecute => 'Execute';

  @override
  String get apiStatus => 'Status';

  @override
  String get apiHeaders => 'Headers';

  @override
  String get apiBody => 'Body';

  @override
  String get apiNoBaseUrl => 'No base URL available';

  @override
  String get apiBaseUrl => 'Base URL';

  @override
  String get apiBaseUrlOverrideHint => 'Override (optional)';

  @override
  String get apiDuration => 'Duration';

  @override
  String get apiCopyUrl => 'Copy URL';

  @override
  String get apiCopiedUrl => 'Copied URL';

  @override
  String get apiCopyBody => 'Copy body';

  @override
  String get apiCopiedBody => 'Copied body';

  @override
  String get apiMockMode => 'Mock response';

  @override
  String get contactTitle => 'Get In Touch';

  @override
  String get contactSubtitle =>
      'Have a project in mind or want to discuss backend architecture? I\'d love to hear from you.';

  @override
  String get contactFormTitle => 'Send Message';

  @override
  String get contactFormName => 'Name';

  @override
  String get contactFormNameHint => 'Your full name';

  @override
  String get contactFormEmail => 'Email';

  @override
  String get contactFormEmailHint => 'your.email@example.com';

  @override
  String get contactFormSubject => 'Subject';

  @override
  String get contactFormSubjectHint => 'What\'s this about?';

  @override
  String get contactFormMessage => 'Message';

  @override
  String get contactFormMessageHint =>
      'Tell me about your project or question...';

  @override
  String get contactFormSend => 'Send Message';

  @override
  String get contactFormSending => 'Sending...';

  @override
  String get contactFormSuccess =>
      'Thank you! Your email client should open with the message ready to send.';

  @override
  String get contactFormNameRequired => 'Name is required';

  @override
  String get contactFormEmailRequired => 'Email is required';

  @override
  String get contactFormEmailInvalid => 'Please enter a valid email address';

  @override
  String get contactFormSubjectRequired => 'Subject is required';

  @override
  String get contactFormMessageRequired => 'Message is required';

  @override
  String get contactFormMessageTooShort =>
      'Message must be at least 10 characters';

  @override
  String get contactInfoTitle => 'Contact Information';

  @override
  String get contactInfoDescription =>
      'Feel free to reach out through any of these channels. I typically respond within 24 hours.';

  @override
  String get contactResponseTime =>
      'I typically respond within 24 hours during business days.';

  @override
  String get navSearch => 'Search';

  @override
  String get searchPageTitle => 'Search';

  @override
  String get searchHint => 'Search projects and blog posts...';

  @override
  String get searchRecentSearches => 'Recent searches';

  @override
  String get searchClearHistory => 'Clear';

  @override
  String get searchPopularTags => 'Popular tags';

  @override
  String searchNoResults(Object query) {
    return 'No results found for \"$query\"';
  }

  @override
  String get searchNoResultsHint =>
      'Try different keywords or browse our projects and blog posts.';

  @override
  String searchResultsCount(num count, Object query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
    );
    return '$_temp0 for \"$query\"';
  }

  @override
  String searchProjectsSection(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count projects',
      one: '1 project',
    );
    return '$_temp0';
  }

  @override
  String searchPostsSection(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count posts',
      one: '1 post',
    );
    return '$_temp0';
  }

  @override
  String get resumeSummaryTitle => 'Professional Summary';

  @override
  String get resumeExperienceTitle => 'Professional Experience';

  @override
  String get resumeSkillsTitle => 'Technical Skills';

  @override
  String get resumeSkillsProgramming => 'Programming Languages';

  @override
  String get resumeSkillsBackend => 'Backend Technologies';

  @override
  String get resumeSkillsInfrastructure => 'Infrastructure & DevOps';

  @override
  String get resumeSkillsData => 'Data Processing';

  @override
  String get resumeEducationTitle => 'Education';

  @override
  String get resumeCertificationsTitle => 'Certifications';

  @override
  String get resumeProjectsTitle => 'Featured Projects';

  @override
  String get resumeLanguagesTitle => 'Languages';

  @override
  String get resumeInterestsTitle => 'Interests';
}
