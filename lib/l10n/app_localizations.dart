import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_zh.dart';

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
    Locale('ms'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Desmond Liew — Portfolio'**
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

  /// No description provided for @navBlog.
  ///
  /// In en, this message translates to:
  /// **'Blog'**
  String get navBlog;

  /// No description provided for @navLabs.
  ///
  /// In en, this message translates to:
  /// **'Labs'**
  String get navLabs;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get navDiscover;

  /// No description provided for @navPhilosophy.
  ///
  /// In en, this message translates to:
  /// **'Philosophy'**
  String get navPhilosophy;

  /// No description provided for @navFoundation.
  ///
  /// In en, this message translates to:
  /// **'Foundation'**
  String get navFoundation;

  /// No description provided for @navTimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get navTimeline;

  /// No description provided for @navServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get navServices;

  /// No description provided for @navContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get navContact;

  /// No description provided for @navResume.
  ///
  /// In en, this message translates to:
  /// **'Résumé'**
  String get navResume;

  /// No description provided for @navLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get navLogin;

  /// No description provided for @menuTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get menuTheme;

  /// No description provided for @menuThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get menuThemeMode;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @menuPalette.
  ///
  /// In en, this message translates to:
  /// **'Palette'**
  String get menuPalette;

  /// No description provided for @paletteMetal.
  ///
  /// In en, this message translates to:
  /// **'Metal'**
  String get paletteMetal;

  /// No description provided for @paletteEarth.
  ///
  /// In en, this message translates to:
  /// **'Earth'**
  String get paletteEarth;

  /// No description provided for @paletteWood.
  ///
  /// In en, this message translates to:
  /// **'Wood'**
  String get paletteWood;

  /// No description provided for @paletteFire.
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get paletteFire;

  /// No description provided for @paletteWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get paletteWater;

  /// No description provided for @menuLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get menuLanguage;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langChinese.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get langChinese;

  /// No description provided for @langMalay.
  ///
  /// In en, this message translates to:
  /// **'Bahasa Melayu'**
  String get langMalay;

  /// No description provided for @homeTagline.
  ///
  /// In en, this message translates to:
  /// **'Applied AI Engineer · System Architect'**
  String get homeTagline;

  /// No description provided for @navWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get navWork;

  /// No description provided for @navAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get navAbout;

  /// No description provided for @navPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get navPeople;

  /// No description provided for @navCredits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get navCredits;

  /// No description provided for @navLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get navLogout;

  /// No description provided for @authUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter passphrase to unlock private content'**
  String get authUnlockTitle;

  /// No description provided for @authPassphraseLabel.
  ///
  /// In en, this message translates to:
  /// **'Passphrase'**
  String get authPassphraseLabel;

  /// No description provided for @authUnlockButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get authUnlockButton;

  /// No description provided for @authAlreadyLoggedInTitle.
  ///
  /// In en, this message translates to:
  /// **'You are logged in.'**
  String get authAlreadyLoggedInTitle;

  /// No description provided for @authAlreadyLoggedInBody.
  ///
  /// In en, this message translates to:
  /// **'Private items are visible.\nThis passphrase is stored locally until you log out.'**
  String get authAlreadyLoggedInBody;

  /// No description provided for @authWrongPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Wrong passphrase'**
  String get authWrongPassphrase;

  /// No description provided for @authUnlockSuccess.
  ///
  /// In en, this message translates to:
  /// **'Unlocked — private content will be shown.'**
  String get authUnlockSuccess;

  /// No description provided for @authCanaryTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: You can add an optional canary in .env to validate the passphrase immediately.'**
  String get authCanaryTip;

  /// No description provided for @lockPrivateTitle.
  ///
  /// In en, this message translates to:
  /// **'This content is private.'**
  String get lockPrivateTitle;

  /// No description provided for @lockPrivateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in with passphrase to view the content.'**
  String get lockPrivateSubtitle;

  /// No description provided for @lockGoToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to Login'**
  String get lockGoToLogin;

  /// No description provided for @visibilityPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get visibilityPrivate;

  /// No description provided for @visibilityPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get visibilityPublic;

  /// No description provided for @notFound404.
  ///
  /// In en, this message translates to:
  /// **'404 — Not Found'**
  String get notFound404;

  /// No description provided for @notFoundGeneric.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notFoundGeneric;

  /// No description provided for @notFoundPage.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get notFoundPage;

  /// No description provided for @metaDisabled.
  ///
  /// In en, this message translates to:
  /// **'Meta realm is disabled.'**
  String get metaDisabled;

  /// No description provided for @timelineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Milestones & significant updates'**
  String get timelineSubtitle;

  /// No description provided for @timelineEmpty.
  ///
  /// In en, this message translates to:
  /// **'No timeline entries yet.'**
  String get timelineEmpty;

  /// No description provided for @workSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get workSectionTitle;

  /// No description provided for @workSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Projects and Lab Experiments'**
  String get workSectionSubtitle;

  /// No description provided for @workFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get workFilterAll;

  /// No description provided for @workFilterProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get workFilterProjects;

  /// No description provided for @workFilterLabs.
  ///
  /// In en, this message translates to:
  /// **'Labs'**
  String get workFilterLabs;

  /// No description provided for @workEmpty.
  ///
  /// In en, this message translates to:
  /// **'No items yet.'**
  String get workEmpty;

  /// No description provided for @workFilterProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get workFilterProducts;

  /// No description provided for @workProductsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Products & Templates'**
  String get workProductsSectionTitle;

  /// No description provided for @workProductsSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reusable tools, starter kits, and templates you can adopt in your own systems.'**
  String get workProductsSectionSubtitle;

  /// No description provided for @blogSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Applied notes on engineering, evaluation, and calm systems.'**
  String get blogSectionSubtitle;

  /// No description provided for @blogEmpty.
  ///
  /// In en, this message translates to:
  /// **'No blog posts yet.'**
  String get blogEmpty;

  /// No description provided for @blogFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All posts'**
  String get blogFilterAll;

  /// No description provided for @librarySectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Inputs to my thinking: readings, tools, press, and research notes.'**
  String get librarySectionSubtitle;

  /// No description provided for @libraryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No library entries yet.'**
  String get libraryEmpty;

  /// No description provided for @libraryFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All entries'**
  String get libraryFilterAll;

  /// No description provided for @peopleSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The thinkers, mentors, and influences behind my work.'**
  String get peopleSectionSubtitle;

  /// No description provided for @peopleEmpty.
  ///
  /// In en, this message translates to:
  /// **'No people profiles yet.'**
  String get peopleEmpty;

  /// No description provided for @peopleFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All people'**
  String get peopleFilterAll;
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
      <String>['en', 'ms', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ms':
      return AppLocalizationsMs();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
