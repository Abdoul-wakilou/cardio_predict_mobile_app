import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'CardioPredict'**
  String get appTitle;

  /// No description provided for @languageSwitchLabel.
  ///
  /// In fr, this message translates to:
  /// **'Langue de l’application'**
  String get languageSwitchLabel;

  /// No description provided for @disclaimerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Avertissement médical'**
  String get disclaimerTitle;

  /// No description provided for @disclaimerBody.
  ///
  /// In fr, this message translates to:
  /// **'CardioPredict est un outil d’aide à la décision et ne pose pas de diagnostic. Ce résultat est une estimation statistique : il doit être interprété par un professionnel de santé, avec l’ensemble du dossier clinique.'**
  String get disclaimerBody;

  /// No description provided for @disclaimerShort.
  ///
  /// In fr, this message translates to:
  /// **'Outil d’aide à la décision. Ne remplace pas l’avis d’un professionnel de santé.'**
  String get disclaimerShort;

  /// No description provided for @homeTagline.
  ///
  /// In fr, this message translates to:
  /// **'Aide à la décision pour estimer le risque cardiovasculaire de vos patients'**
  String get homeTagline;

  /// No description provided for @homeFeatureClinicalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Analyse médicale avancée'**
  String get homeFeatureClinicalTitle;

  /// No description provided for @homeFeatureClinicalBody.
  ///
  /// In fr, this message translates to:
  /// **'Basée sur 13 paramètres cliniques'**
  String get homeFeatureClinicalBody;

  /// No description provided for @homeFeatureAiTitle.
  ///
  /// In fr, this message translates to:
  /// **'Intelligence artificielle'**
  String get homeFeatureAiTitle;

  /// No description provided for @homeFeatureAiBody.
  ///
  /// In fr, this message translates to:
  /// **'Modèle Random Forest, jeu de données de 834 patients'**
  String get homeFeatureAiBody;

  /// No description provided for @homeFeaturePrivacyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Respect de la confidentialité'**
  String get homeFeaturePrivacyTitle;

  /// No description provided for @homeFeaturePrivacyBody.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée n’est stockée après l’analyse'**
  String get homeFeaturePrivacyBody;

  /// No description provided for @homeCta.
  ///
  /// In fr, this message translates to:
  /// **'Démarrer l’évaluation'**
  String get homeCta;

  /// No description provided for @aboutTitle.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get aboutTitle;

  /// No description provided for @aboutHeadline.
  ///
  /// In fr, this message translates to:
  /// **'Évaluation du risque cardiovasculaire'**
  String get aboutHeadline;

  /// No description provided for @aboutSubheadline.
  ///
  /// In fr, this message translates to:
  /// **'Une aide à la décision médicale basée sur l’intelligence artificielle'**
  String get aboutSubheadline;

  /// No description provided for @aboutBody.
  ///
  /// In fr, this message translates to:
  /// **'CardioPredict analyse des paramètres cliniques afin d’estimer le risque cardiovasculaire, à partir d’un modèle d’intelligence artificielle construit sur un jeu de données de 834 patients.'**
  String get aboutBody;

  /// No description provided for @aboutHighlights.
  ///
  /// In fr, this message translates to:
  /// **'Évaluation rapide • Résultat immédiat • Utilisation simple'**
  String get aboutHighlights;

  /// No description provided for @aboutHowItWorks.
  ///
  /// In fr, this message translates to:
  /// **'Comment ça marche'**
  String get aboutHowItWorks;

  /// No description provided for @aboutStepInputTitle.
  ///
  /// In fr, this message translates to:
  /// **'Saisie des données'**
  String get aboutStepInputTitle;

  /// No description provided for @aboutStepInputBody.
  ///
  /// In fr, this message translates to:
  /// **'Saisie des paramètres cliniques essentiels'**
  String get aboutStepInputBody;

  /// No description provided for @aboutStepAnalysisTitle.
  ///
  /// In fr, this message translates to:
  /// **'Analyse par le modèle'**
  String get aboutStepAnalysisTitle;

  /// No description provided for @aboutStepAnalysisBody.
  ///
  /// In fr, this message translates to:
  /// **'Analyse automatique par un modèle d’intelligence artificielle'**
  String get aboutStepAnalysisBody;

  /// No description provided for @aboutStepResultTitle.
  ///
  /// In fr, this message translates to:
  /// **'Résultats'**
  String get aboutStepResultTitle;

  /// No description provided for @aboutStepResultBody.
  ///
  /// In fr, this message translates to:
  /// **'Affichage du niveau de risque et des recommandations associées'**
  String get aboutStepResultBody;

  /// No description provided for @aboutInfoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations importantes'**
  String get aboutInfoTitle;

  /// No description provided for @aboutInfoNoStorage.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée personnelle n’est stockée'**
  String get aboutInfoNoStorage;

  /// No description provided for @aboutInfoRealTime.
  ///
  /// In fr, this message translates to:
  /// **'Analyse effectuée en temps réel'**
  String get aboutInfoRealTime;

  /// No description provided for @aboutInfoInformative.
  ///
  /// In fr, this message translates to:
  /// **'Résultats à usage informatif uniquement'**
  String get aboutInfoInformative;

  /// No description provided for @aboutInfoConsult.
  ///
  /// In fr, this message translates to:
  /// **'Consultez un médecin pour un diagnostic'**
  String get aboutInfoConsult;

  /// No description provided for @aboutCta.
  ///
  /// In fr, this message translates to:
  /// **'Commencer l’évaluation'**
  String get aboutCta;

  /// No description provided for @aboutDevelopedBy.
  ///
  /// In fr, this message translates to:
  /// **'Développé par'**
  String get aboutDevelopedBy;

  /// No description provided for @aboutContext.
  ///
  /// In fr, this message translates to:
  /// **'Application développée dans le cadre d’un mémoire de master en Génie Logiciel à l’IFRI/UAC'**
  String get aboutContext;

  /// No description provided for @formTitle.
  ///
  /// In fr, this message translates to:
  /// **'Évaluation cardiaque'**
  String get formTitle;

  /// No description provided for @stepOf.
  ///
  /// In fr, this message translates to:
  /// **'Étape {current} sur {total}'**
  String stepOf(int current, int total);

  /// No description provided for @stepDemographicsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations démographiques'**
  String get stepDemographicsTitle;

  /// No description provided for @stepDemographicsShort.
  ///
  /// In fr, this message translates to:
  /// **'Démographie'**
  String get stepDemographicsShort;

  /// No description provided for @stepDemographicsBody.
  ///
  /// In fr, this message translates to:
  /// **'Âge et sexe biologique'**
  String get stepDemographicsBody;

  /// No description provided for @stepPhysiologyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres physiologiques'**
  String get stepPhysiologyTitle;

  /// No description provided for @stepPhysiologyShort.
  ///
  /// In fr, this message translates to:
  /// **'Physiologie'**
  String get stepPhysiologyShort;

  /// No description provided for @stepPhysiologyBody.
  ///
  /// In fr, this message translates to:
  /// **'Pression artérielle et fréquence cardiaque'**
  String get stepPhysiologyBody;

  /// No description provided for @stepBiologyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Analyses biologiques'**
  String get stepBiologyTitle;

  /// No description provided for @stepBiologyShort.
  ///
  /// In fr, this message translates to:
  /// **'Biologie'**
  String get stepBiologyShort;

  /// No description provided for @stepBiologyBody.
  ///
  /// In fr, this message translates to:
  /// **'Cholestérol et glycémie'**
  String get stepBiologyBody;

  /// No description provided for @stepClinicalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Données cliniques'**
  String get stepClinicalTitle;

  /// No description provided for @stepClinicalShort.
  ///
  /// In fr, this message translates to:
  /// **'Clinique'**
  String get stepClinicalShort;

  /// No description provided for @stepClinicalBody.
  ///
  /// In fr, this message translates to:
  /// **'ECG, douleurs thoraciques et tests'**
  String get stepClinicalBody;

  /// No description provided for @actionPrevious.
  ///
  /// In fr, this message translates to:
  /// **'Précédent'**
  String get actionPrevious;

  /// No description provided for @actionContinue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get actionContinue;

  /// No description provided for @actionAnalyze.
  ///
  /// In fr, this message translates to:
  /// **'Analyser le risque'**
  String get actionAnalyze;

  /// No description provided for @actionRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get actionRetry;

  /// No description provided for @unitYears.
  ///
  /// In fr, this message translates to:
  /// **'ans'**
  String get unitYears;

  /// No description provided for @unitMmHg.
  ///
  /// In fr, this message translates to:
  /// **'mmHg'**
  String get unitMmHg;

  /// No description provided for @unitBpm.
  ///
  /// In fr, this message translates to:
  /// **'bpm'**
  String get unitBpm;

  /// No description provided for @unitMgDl.
  ///
  /// In fr, this message translates to:
  /// **'mg/dL'**
  String get unitMgDl;

  /// No description provided for @unitMm.
  ///
  /// In fr, this message translates to:
  /// **'mm'**
  String get unitMm;

  /// No description provided for @fieldAge.
  ///
  /// In fr, this message translates to:
  /// **'Âge du patient'**
  String get fieldAge;

  /// No description provided for @fieldAgeHelp.
  ///
  /// In fr, this message translates to:
  /// **'Plage acceptée : 1 – 120 ans'**
  String get fieldAgeHelp;

  /// No description provided for @fieldRestingBp.
  ///
  /// In fr, this message translates to:
  /// **'Pression artérielle au repos'**
  String get fieldRestingBp;

  /// No description provided for @fieldRestingBpHelp.
  ///
  /// In fr, this message translates to:
  /// **'Plage acceptée : 50 – 250 mmHg • Normale : 90–120'**
  String get fieldRestingBpHelp;

  /// No description provided for @fieldMaxHr.
  ///
  /// In fr, this message translates to:
  /// **'Fréquence cardiaque maximale'**
  String get fieldMaxHr;

  /// No description provided for @fieldMaxHrHelp.
  ///
  /// In fr, this message translates to:
  /// **'Plage acceptée : 50 – 250 bpm • Normale : 60–200'**
  String get fieldMaxHrHelp;

  /// No description provided for @fieldCholesterol.
  ///
  /// In fr, this message translates to:
  /// **'Cholestérol sérique'**
  String get fieldCholesterol;

  /// No description provided for @fieldCholesterolHelp.
  ///
  /// In fr, this message translates to:
  /// **'Plage acceptée : 50 – 700 mg/dL • Normale : < 200'**
  String get fieldCholesterolHelp;

  /// No description provided for @fieldStDepression.
  ///
  /// In fr, this message translates to:
  /// **'Dépression du segment ST'**
  String get fieldStDepression;

  /// No description provided for @fieldStDepressionHelp.
  ///
  /// In fr, this message translates to:
  /// **'Plage acceptée : -5 – 10 mm • Normale : 0–2'**
  String get fieldStDepressionHelp;

  /// No description provided for @fieldSex.
  ///
  /// In fr, this message translates to:
  /// **'Sexe biologique'**
  String get fieldSex;

  /// No description provided for @fieldFastingSugar.
  ///
  /// In fr, this message translates to:
  /// **'Glycémie à jeun > 120 mg/dL'**
  String get fieldFastingSugar;

  /// No description provided for @fieldChestPain.
  ///
  /// In fr, this message translates to:
  /// **'Type de douleur thoracique'**
  String get fieldChestPain;

  /// No description provided for @fieldRestingEcg.
  ///
  /// In fr, this message translates to:
  /// **'Résultats ECG au repos'**
  String get fieldRestingEcg;

  /// No description provided for @fieldExerciseAngina.
  ///
  /// In fr, this message translates to:
  /// **'Angine induite par l’effort'**
  String get fieldExerciseAngina;

  /// No description provided for @fieldStSlope.
  ///
  /// In fr, this message translates to:
  /// **'Pente du segment ST à l’effort'**
  String get fieldStSlope;

  /// No description provided for @fieldThallium.
  ///
  /// In fr, this message translates to:
  /// **'Résultat de la scintigraphie au thallium'**
  String get fieldThallium;

  /// No description provided for @fieldVessels.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de vaisseaux colorés (fluoroscopie)'**
  String get fieldVessels;

  /// No description provided for @optionWoman.
  ///
  /// In fr, this message translates to:
  /// **'Femme'**
  String get optionWoman;

  /// No description provided for @optionWomanBody.
  ///
  /// In fr, this message translates to:
  /// **'Sexe féminin'**
  String get optionWomanBody;

  /// No description provided for @optionMan.
  ///
  /// In fr, this message translates to:
  /// **'Homme'**
  String get optionMan;

  /// No description provided for @optionManBody.
  ///
  /// In fr, this message translates to:
  /// **'Sexe masculin'**
  String get optionManBody;

  /// No description provided for @optionNo.
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get optionNo;

  /// No description provided for @optionYes.
  ///
  /// In fr, this message translates to:
  /// **'Oui'**
  String get optionYes;

  /// No description provided for @optionSugarNoBody.
  ///
  /// In fr, this message translates to:
  /// **'Glycémie normale'**
  String get optionSugarNoBody;

  /// No description provided for @optionSugarYesBody.
  ///
  /// In fr, this message translates to:
  /// **'Glycémie élevée'**
  String get optionSugarYesBody;

  /// No description provided for @optionAnginaNoBody.
  ///
  /// In fr, this message translates to:
  /// **'Aucune douleur à l’effort'**
  String get optionAnginaNoBody;

  /// No description provided for @optionAnginaYesBody.
  ///
  /// In fr, this message translates to:
  /// **'Douleur présente à l’effort'**
  String get optionAnginaYesBody;

  /// No description provided for @optionPainTypical.
  ///
  /// In fr, this message translates to:
  /// **'Angine typique'**
  String get optionPainTypical;

  /// No description provided for @optionPainTypicalBody.
  ///
  /// In fr, this message translates to:
  /// **'Douleur caractéristique'**
  String get optionPainTypicalBody;

  /// No description provided for @optionPainAtypical.
  ///
  /// In fr, this message translates to:
  /// **'Angine atypique'**
  String get optionPainAtypical;

  /// No description provided for @optionPainAtypicalBody.
  ///
  /// In fr, this message translates to:
  /// **'Douleur non caractéristique'**
  String get optionPainAtypicalBody;

  /// No description provided for @optionPainNonAnginal.
  ///
  /// In fr, this message translates to:
  /// **'Douleur non angineuse'**
  String get optionPainNonAnginal;

  /// No description provided for @optionPainNonAnginalBody.
  ///
  /// In fr, this message translates to:
  /// **'Douleur non liée au cœur'**
  String get optionPainNonAnginalBody;

  /// No description provided for @optionPainNone.
  ///
  /// In fr, this message translates to:
  /// **'Asymptomatique'**
  String get optionPainNone;

  /// No description provided for @optionPainNoneBody.
  ///
  /// In fr, this message translates to:
  /// **'Aucune douleur'**
  String get optionPainNoneBody;

  /// No description provided for @optionEcgNormal.
  ///
  /// In fr, this message translates to:
  /// **'Normal'**
  String get optionEcgNormal;

  /// No description provided for @optionEcgNormalBody.
  ///
  /// In fr, this message translates to:
  /// **'ECG normal'**
  String get optionEcgNormalBody;

  /// No description provided for @optionEcgSt.
  ///
  /// In fr, this message translates to:
  /// **'Anomalie onde ST-T'**
  String get optionEcgSt;

  /// No description provided for @optionEcgStBody.
  ///
  /// In fr, this message translates to:
  /// **'Anomalie détectée'**
  String get optionEcgStBody;

  /// No description provided for @optionEcgLvh.
  ///
  /// In fr, this message translates to:
  /// **'Hypertrophie ventriculaire'**
  String get optionEcgLvh;

  /// No description provided for @optionEcgLvhBody.
  ///
  /// In fr, this message translates to:
  /// **'HVG probable'**
  String get optionEcgLvhBody;

  /// No description provided for @optionSlopeUp.
  ///
  /// In fr, this message translates to:
  /// **'Ascendante'**
  String get optionSlopeUp;

  /// No description provided for @optionSlopeUpBody.
  ///
  /// In fr, this message translates to:
  /// **'Pente positive'**
  String get optionSlopeUpBody;

  /// No description provided for @optionSlopeFlat.
  ///
  /// In fr, this message translates to:
  /// **'Plate'**
  String get optionSlopeFlat;

  /// No description provided for @optionSlopeFlatBody.
  ///
  /// In fr, this message translates to:
  /// **'Pente nulle'**
  String get optionSlopeFlatBody;

  /// No description provided for @optionSlopeDown.
  ///
  /// In fr, this message translates to:
  /// **'Descendante'**
  String get optionSlopeDown;

  /// No description provided for @optionSlopeDownBody.
  ///
  /// In fr, this message translates to:
  /// **'Pente négative'**
  String get optionSlopeDownBody;

  /// No description provided for @optionThalNormal.
  ///
  /// In fr, this message translates to:
  /// **'Normal'**
  String get optionThalNormal;

  /// No description provided for @optionThalNormalBody.
  ///
  /// In fr, this message translates to:
  /// **'Examen normal'**
  String get optionThalNormalBody;

  /// No description provided for @optionThalFixed.
  ///
  /// In fr, this message translates to:
  /// **'Défaut fixe'**
  String get optionThalFixed;

  /// No description provided for @optionThalFixedBody.
  ///
  /// In fr, this message translates to:
  /// **'Anomalie fixe détectée'**
  String get optionThalFixedBody;

  /// No description provided for @optionThalReversible.
  ///
  /// In fr, this message translates to:
  /// **'Défaut réversible'**
  String get optionThalReversible;

  /// No description provided for @optionThalReversibleBody.
  ///
  /// In fr, this message translates to:
  /// **'Anomalie réversible'**
  String get optionThalReversibleBody;

  /// No description provided for @optionVessels0Body.
  ///
  /// In fr, this message translates to:
  /// **'Aucun vaisseau'**
  String get optionVessels0Body;

  /// No description provided for @optionVessels1Body.
  ///
  /// In fr, this message translates to:
  /// **'Un vaisseau'**
  String get optionVessels1Body;

  /// No description provided for @optionVessels2Body.
  ///
  /// In fr, this message translates to:
  /// **'Deux vaisseaux'**
  String get optionVessels2Body;

  /// No description provided for @optionVessels3Body.
  ///
  /// In fr, this message translates to:
  /// **'Trois vaisseaux'**
  String get optionVessels3Body;

  /// No description provided for @errorRequired.
  ///
  /// In fr, this message translates to:
  /// **'Ce champ est obligatoire'**
  String get errorRequired;

  /// No description provided for @errorInvalidNumber.
  ///
  /// In fr, this message translates to:
  /// **'Valeur numérique invalide'**
  String get errorInvalidNumber;

  /// No description provided for @errorMin.
  ///
  /// In fr, this message translates to:
  /// **'Minimum : {value} {unit}'**
  String errorMin(String value, String unit);

  /// No description provided for @errorMax.
  ///
  /// In fr, this message translates to:
  /// **'Maximum : {value} {unit}'**
  String errorMax(String value, String unit);

  /// No description provided for @errorChoiceRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner une option'**
  String get errorChoiceRequired;

  /// No description provided for @loadingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Analyse en cours…'**
  String get loadingTitle;

  /// No description provided for @loadingBody.
  ///
  /// In fr, this message translates to:
  /// **'Le modèle analyse les données saisies pour estimer le risque cardiovasculaire'**
  String get loadingBody;

  /// No description provided for @failureTitle.
  ///
  /// In fr, this message translates to:
  /// **'L’analyse n’a pas abouti'**
  String get failureTitle;

  /// No description provided for @failureNotConfigured.
  ///
  /// In fr, this message translates to:
  /// **'L’application n’est pas configurée pour joindre le serveur d’analyse. Contactez l’administrateur.'**
  String get failureNotConfigured;

  /// No description provided for @failureNoConnection.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de joindre le serveur. Vérifiez la connexion internet, puis réessayez.'**
  String get failureNoConnection;

  /// No description provided for @failureTimeout.
  ///
  /// In fr, this message translates to:
  /// **'Le serveur met trop de temps à répondre. Réessayez dans un instant.'**
  String get failureTimeout;

  /// No description provided for @failureServerUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Le serveur d’analyse est momentanément indisponible. Réessayez plus tard.'**
  String get failureServerUnavailable;

  /// No description provided for @failureRejected.
  ///
  /// In fr, this message translates to:
  /// **'Le serveur a refusé ces données. Vérifiez les valeurs saisies.'**
  String get failureRejected;

  /// No description provided for @failureInvalidResponse.
  ///
  /// In fr, this message translates to:
  /// **'Le serveur a renvoyé une réponse inattendue. Aucun résultat ne peut être affiché.'**
  String get failureInvalidResponse;

  /// No description provided for @resultTitle.
  ///
  /// In fr, this message translates to:
  /// **'Résultats de l’analyse'**
  String get resultTitle;

  /// No description provided for @probabilityLabel.
  ///
  /// In fr, this message translates to:
  /// **'Probabilité estimée par le modèle'**
  String get probabilityLabel;

  /// No description provided for @riskVeryLow.
  ///
  /// In fr, this message translates to:
  /// **'Risque très faible'**
  String get riskVeryLow;

  /// No description provided for @riskLow.
  ///
  /// In fr, this message translates to:
  /// **'Risque faible'**
  String get riskLow;

  /// No description provided for @riskModerate.
  ///
  /// In fr, this message translates to:
  /// **'Risque modéré'**
  String get riskModerate;

  /// No description provided for @riskHigh.
  ///
  /// In fr, this message translates to:
  /// **'Risque élevé'**
  String get riskHigh;

  /// No description provided for @riskVeryHigh.
  ///
  /// In fr, this message translates to:
  /// **'Risque très élevé'**
  String get riskVeryHigh;

  /// No description provided for @riskDescriptionVeryLow.
  ///
  /// In fr, this message translates to:
  /// **'Probabilité estimée très faible. Bilan annuel recommandé.'**
  String get riskDescriptionVeryLow;

  /// No description provided for @riskDescriptionLow.
  ///
  /// In fr, this message translates to:
  /// **'Risque faible détecté. Surveillance médicale régulière.'**
  String get riskDescriptionLow;

  /// No description provided for @riskDescriptionModerate.
  ///
  /// In fr, this message translates to:
  /// **'Risque modéré. Consultation médicale dans le mois.'**
  String get riskDescriptionModerate;

  /// No description provided for @riskDescriptionHigh.
  ///
  /// In fr, this message translates to:
  /// **'Risque élevé. Consultation cardiologique rapide (sous 8 jours).'**
  String get riskDescriptionHigh;

  /// No description provided for @riskDescriptionVeryHigh.
  ///
  /// In fr, this message translates to:
  /// **'Risque très élevé. Consultation urgente (sous 48 h).'**
  String get riskDescriptionVeryHigh;

  /// No description provided for @verdictUnlikely.
  ///
  /// In fr, this message translates to:
  /// **'Maladie coronarienne peu probable selon le modèle'**
  String get verdictUnlikely;

  /// No description provided for @verdictLikely.
  ///
  /// In fr, this message translates to:
  /// **'Maladie coronarienne probable selon le modèle'**
  String get verdictLikely;

  /// No description provided for @riskScaleTitle.
  ///
  /// In fr, this message translates to:
  /// **'Niveau de risque'**
  String get riskScaleTitle;

  /// No description provided for @scaleVeryLow.
  ///
  /// In fr, this message translates to:
  /// **'Très faible'**
  String get scaleVeryLow;

  /// No description provided for @scaleLow.
  ///
  /// In fr, this message translates to:
  /// **'Faible'**
  String get scaleLow;

  /// No description provided for @scaleModerate.
  ///
  /// In fr, this message translates to:
  /// **'Modéré'**
  String get scaleModerate;

  /// No description provided for @scaleHigh.
  ///
  /// In fr, this message translates to:
  /// **'Élevé'**
  String get scaleHigh;

  /// No description provided for @scaleVeryHigh.
  ///
  /// In fr, this message translates to:
  /// **'Très élevé'**
  String get scaleVeryHigh;

  /// No description provided for @recommendationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recommandations'**
  String get recommendationsTitle;

  /// No description provided for @recommendationsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune recommandation disponible'**
  String get recommendationsEmpty;

  /// No description provided for @recommendationsLanguageNote.
  ///
  /// In fr, this message translates to:
  /// **'Les recommandations sont fournies par le serveur et ne sont pas encore traduites.'**
  String get recommendationsLanguageNote;

  /// No description provided for @actionNewAssessment.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle analyse'**
  String get actionNewAssessment;

  /// No description provided for @actionHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get actionHome;
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
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
