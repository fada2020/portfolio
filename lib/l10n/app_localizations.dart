import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Full-stack Portfolio'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get navProjects;

  /// No description provided for @navApi.
  ///
  /// In en, this message translates to:
  /// **'API'**
  String get navApi;

  /// No description provided for @navBlog.
  ///
  /// In en, this message translates to:
  /// **'Blog'**
  String get navBlog;

  /// No description provided for @navResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get navResume;

  /// No description provided for @navContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get navContact;

  /// No description provided for @languageKorean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get languageKorean;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @homeFeaturedProjects.
  ///
  /// In en, this message translates to:
  /// **'Featured Projects'**
  String get homeFeaturedProjects;

  /// No description provided for @homeRecentPosts.
  ///
  /// In en, this message translates to:
  /// **'Recent Posts'**
  String get homeRecentPosts;

  /// No description provided for @commonViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get commonViewAll;

  /// No description provided for @commonDownloadResume.
  ///
  /// In en, this message translates to:
  /// **'Download Resume'**
  String get commonDownloadResume;

  /// No description provided for @commonBlog.
  ///
  /// In en, this message translates to:
  /// **'Blog'**
  String get commonBlog;

  /// No description provided for @commonContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get commonContact;

  /// No description provided for @homeNoProjects.
  ///
  /// In en, this message translates to:
  /// **'No projects yet.'**
  String get homeNoProjects;

  /// No description provided for @homeNoPosts.
  ///
  /// In en, this message translates to:
  /// **'No posts yet.'**
  String get homeNoPosts;

  /// No description provided for @errLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get errLoadProfile;

  /// No description provided for @errLoadProjects.
  ///
  /// In en, this message translates to:
  /// **'Failed to load projects'**
  String get errLoadProjects;

  /// No description provided for @errLoadPosts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load posts'**
  String get errLoadPosts;

  /// No description provided for @projectsFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get projectsFilters;

  /// No description provided for @projectsStacks.
  ///
  /// In en, this message translates to:
  /// **'Stacks'**
  String get projectsStacks;

  /// No description provided for @projectsDomains.
  ///
  /// In en, this message translates to:
  /// **'Domains'**
  String get projectsDomains;

  /// No description provided for @projectsSortLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get projectsSortLatest;

  /// No description provided for @projectsSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Title A-Z'**
  String get projectsSortTitle;

  /// No description provided for @projectsClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get projectsClear;

  /// No description provided for @projectsNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No projects match filters.'**
  String get projectsNoMatch;

  /// No description provided for @projectNotFound.
  ///
  /// In en, this message translates to:
  /// **'Project not found'**
  String get projectNotFound;

  /// No description provided for @projectKeyMetrics.
  ///
  /// In en, this message translates to:
  /// **'Key Metrics'**
  String get projectKeyMetrics;

  /// No description provided for @projectRepository.
  ///
  /// In en, this message translates to:
  /// **'Repository'**
  String get projectRepository;

  /// No description provided for @projectDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo'**
  String get projectDemo;

  /// No description provided for @projectCaseStudy.
  ///
  /// In en, this message translates to:
  /// **'Case Study'**
  String get projectCaseStudy;

  /// No description provided for @projectNoDetail.
  ///
  /// In en, this message translates to:
  /// **'No detail available.'**
  String get projectNoDetail;

  /// No description provided for @projectLoadBodyError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load detail: {error}'**
  String projectLoadBodyError(Object error);

  /// No description provided for @projectLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load project: {error}'**
  String projectLoadError(Object error);

  /// No description provided for @blogSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search title'**
  String get blogSearchTitle;

  /// No description provided for @commonTag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get commonTag;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @errFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get errFailedToLoad;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get goHome;

  /// No description provided for @commonMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get commonMenu;

  /// No description provided for @commonLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get commonLanguage;

  /// No description provided for @commonToggleTheme.
  ///
  /// In en, this message translates to:
  /// **'Toggle theme'**
  String get commonToggleTheme;

  /// No description provided for @skipToContent.
  ///
  /// In en, this message translates to:
  /// **'Skip to content'**
  String get skipToContent;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyTitle;

  /// No description provided for @appPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'App Privacy Policy'**
  String get appPrivacyTitle;

  /// No description provided for @apiSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search path, summary, operationId'**
  String get apiSearchHint;

  /// No description provided for @apiGroupByTag.
  ///
  /// In en, this message translates to:
  /// **'Group by tag'**
  String get apiGroupByTag;

  /// No description provided for @apiIncludeAuth.
  ///
  /// In en, this message translates to:
  /// **'Include Authorization'**
  String get apiIncludeAuth;

  /// No description provided for @apiAuthToken.
  ///
  /// In en, this message translates to:
  /// **'Bearer token'**
  String get apiAuthToken;

  /// No description provided for @apiUntagged.
  ///
  /// In en, this message translates to:
  /// **'Untagged'**
  String get apiUntagged;

  /// No description provided for @apiParameters.
  ///
  /// In en, this message translates to:
  /// **'Parameters'**
  String get apiParameters;

  /// No description provided for @apiRequestBodyJson.
  ///
  /// In en, this message translates to:
  /// **'Request Body (application/json)'**
  String get apiRequestBodyJson;

  /// No description provided for @apiResponseJson.
  ///
  /// In en, this message translates to:
  /// **'Response (application/json, 2xx)'**
  String get apiResponseJson;

  /// No description provided for @apiCurlTitle.
  ///
  /// In en, this message translates to:
  /// **'cURL'**
  String get apiCurlTitle;

  /// No description provided for @apiCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get apiCopy;

  /// No description provided for @apiCopiedCurl.
  ///
  /// In en, this message translates to:
  /// **'Copied cURL'**
  String get apiCopiedCurl;

  /// No description provided for @errLoadSpec.
  ///
  /// In en, this message translates to:
  /// **'Failed to load spec'**
  String get errLoadSpec;

  /// No description provided for @apiTryGet.
  ///
  /// In en, this message translates to:
  /// **'Try (GET)'**
  String get apiTryGet;

  /// No description provided for @apiTry.
  ///
  /// In en, this message translates to:
  /// **'Try'**
  String get apiTry;

  /// No description provided for @apiExecute.
  ///
  /// In en, this message translates to:
  /// **'Execute'**
  String get apiExecute;

  /// No description provided for @apiStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get apiStatus;

  /// No description provided for @apiHeaders.
  ///
  /// In en, this message translates to:
  /// **'Headers'**
  String get apiHeaders;

  /// No description provided for @apiBody.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get apiBody;

  /// No description provided for @apiNoBaseUrl.
  ///
  /// In en, this message translates to:
  /// **'No base URL available'**
  String get apiNoBaseUrl;

  /// No description provided for @apiBaseUrl.
  ///
  /// In en, this message translates to:
  /// **'Base URL'**
  String get apiBaseUrl;

  /// No description provided for @apiBaseUrlOverrideHint.
  ///
  /// In en, this message translates to:
  /// **'Override (optional)'**
  String get apiBaseUrlOverrideHint;

  /// No description provided for @apiDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get apiDuration;

  /// No description provided for @apiCopyUrl.
  ///
  /// In en, this message translates to:
  /// **'Copy URL'**
  String get apiCopyUrl;

  /// No description provided for @apiCopiedUrl.
  ///
  /// In en, this message translates to:
  /// **'Copied URL'**
  String get apiCopiedUrl;

  /// No description provided for @apiCopyBody.
  ///
  /// In en, this message translates to:
  /// **'Copy body'**
  String get apiCopyBody;

  /// No description provided for @apiCopiedBody.
  ///
  /// In en, this message translates to:
  /// **'Copied body'**
  String get apiCopiedBody;

  /// No description provided for @contactTitle.
  ///
  /// In en, this message translates to:
  /// **'Get In Touch'**
  String get contactTitle;

  /// No description provided for @contactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Have a project in mind or want to discuss backend architecture? I\'d love to hear from you.'**
  String get contactSubtitle;

  /// No description provided for @contactFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get contactFormTitle;

  /// No description provided for @contactFormName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get contactFormName;

  /// No description provided for @contactFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get contactFormNameHint;

  /// No description provided for @contactFormEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contactFormEmail;

  /// No description provided for @contactFormEmailHint.
  ///
  /// In en, this message translates to:
  /// **'your.email@example.com'**
  String get contactFormEmailHint;

  /// No description provided for @contactFormSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get contactFormSubject;

  /// No description provided for @contactFormSubjectHint.
  ///
  /// In en, this message translates to:
  /// **'What\'s this about?'**
  String get contactFormSubjectHint;

  /// No description provided for @contactFormMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get contactFormMessage;

  /// No description provided for @contactFormMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Tell me about your project or question...'**
  String get contactFormMessageHint;

  /// No description provided for @contactFormSend.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get contactFormSend;

  /// No description provided for @contactFormSending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get contactFormSending;

  /// No description provided for @contactFormSuccess.
  ///
  /// In en, this message translates to:
  /// **'Thank you! Your email client should open with the message ready to send.'**
  String get contactFormSuccess;

  /// No description provided for @contactFormNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get contactFormNameRequired;

  /// No description provided for @contactFormEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get contactFormEmailRequired;

  /// No description provided for @contactFormEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get contactFormEmailInvalid;

  /// No description provided for @contactFormSubjectRequired.
  ///
  /// In en, this message translates to:
  /// **'Subject is required'**
  String get contactFormSubjectRequired;

  /// No description provided for @contactFormMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'Message is required'**
  String get contactFormMessageRequired;

  /// No description provided for @contactFormMessageTooShort.
  ///
  /// In en, this message translates to:
  /// **'Message must be at least 10 characters'**
  String get contactFormMessageTooShort;

  /// No description provided for @contactInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInfoTitle;

  /// No description provided for @contactInfoDescription.
  ///
  /// In en, this message translates to:
  /// **'Feel free to reach out through any of these channels. I typically respond within 24 hours.'**
  String get contactInfoDescription;

  /// No description provided for @contactResponseTime.
  ///
  /// In en, this message translates to:
  /// **'I typically respond within 24 hours during business days.'**
  String get contactResponseTime;

  /// No description provided for @contactMailFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Email client unavailable'**
  String get contactMailFallbackTitle;

  /// No description provided for @contactMailFallbackDescription.
  ///
  /// In en, this message translates to:
  /// **'Copy the email address below and send manually to {email}.'**
  String contactMailFallbackDescription(Object email);

  /// No description provided for @contactCopyEmail.
  ///
  /// In en, this message translates to:
  /// **'Copy email address'**
  String get contactCopyEmail;

  /// No description provided for @contactCopiedEmail.
  ///
  /// In en, this message translates to:
  /// **'Copied email address'**
  String get contactCopiedEmail;

  /// No description provided for @contactMailFallbackError.
  ///
  /// In en, this message translates to:
  /// **'Could not open your email client. Try copying the address instead.'**
  String get contactMailFallbackError;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @searchPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchPageTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search projects and blog posts...'**
  String get searchHint;

  /// No description provided for @searchRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get searchRecentSearches;

  /// No description provided for @searchClearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get searchClearHistory;

  /// No description provided for @searchPopularTags.
  ///
  /// In en, this message translates to:
  /// **'Popular tags'**
  String get searchPopularTags;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found for \"{query}\"'**
  String searchNoResults(Object query);

  /// No description provided for @searchNoResultsHint.
  ///
  /// In en, this message translates to:
  /// **'Try different keywords or browse our projects and blog posts.'**
  String get searchNoResultsHint;

  /// No description provided for @searchResultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 result} other{{count} results}} for \"{query}\"'**
  String searchResultsCount(num count, Object query);

  /// No description provided for @searchProjectsSection.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 project} other{{count} projects}}'**
  String searchProjectsSection(num count);

  /// No description provided for @searchPostsSection.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 post} other{{count} posts}}'**
  String searchPostsSection(num count);

  /// No description provided for @resumeSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Professional Summary'**
  String get resumeSummaryTitle;

  /// No description provided for @resumeExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'Professional Experience'**
  String get resumeExperienceTitle;

  /// No description provided for @resumeSkillsTitle.
  ///
  /// In en, this message translates to:
  /// **'Technical Skills'**
  String get resumeSkillsTitle;

  /// No description provided for @resumeSkillsProgramming.
  ///
  /// In en, this message translates to:
  /// **'Programming Languages'**
  String get resumeSkillsProgramming;

  /// No description provided for @resumeSkillsBackend.
  ///
  /// In en, this message translates to:
  /// **'Backend Technologies'**
  String get resumeSkillsBackend;

  /// No description provided for @resumeSkillsInfrastructure.
  ///
  /// In en, this message translates to:
  /// **'Infrastructure & DevOps'**
  String get resumeSkillsInfrastructure;

  /// No description provided for @resumeSkillsData.
  ///
  /// In en, this message translates to:
  /// **'Data Processing'**
  String get resumeSkillsData;

  /// No description provided for @resumeEducationTitle.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get resumeEducationTitle;

  /// No description provided for @resumeCertificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Certifications'**
  String get resumeCertificationsTitle;

  /// No description provided for @resumeProjectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Featured Projects'**
  String get resumeProjectsTitle;

  /// No description provided for @resumeLanguagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get resumeLanguagesTitle;

  /// No description provided for @resumeInterestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get resumeInterestsTitle;

  /// No description provided for @themeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeModeSystem;

  /// No description provided for @themeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeModeDark;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
