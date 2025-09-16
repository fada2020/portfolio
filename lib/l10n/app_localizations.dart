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
  /// **'Backend Portfolio'**
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

  /// No description provided for @skipToContent.
  ///
  /// In en, this message translates to:
  /// **'Skip to content'**
  String get skipToContent;

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
