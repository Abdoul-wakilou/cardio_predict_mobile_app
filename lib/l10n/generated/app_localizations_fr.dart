// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'CardioPredict';

  @override
  String get languageSwitchLabel => 'Langue de l’application';

  @override
  String get disclaimerTitle => 'Avertissement médical';

  @override
  String get disclaimerBody =>
      'CardioPredict est un outil d’aide à la décision et ne pose pas de diagnostic. Ce résultat est une estimation statistique : il doit être interprété par un professionnel de santé, avec l’ensemble du dossier clinique.';

  @override
  String get disclaimerShort =>
      'Outil d’aide à la décision. Ne remplace pas l’avis d’un professionnel de santé.';

  @override
  String get homeTagline =>
      'Aide à la décision pour estimer le risque cardiovasculaire de vos patients';

  @override
  String get homeFeatureClinicalTitle => 'Analyse médicale avancée';

  @override
  String get homeFeatureClinicalBody => 'Basée sur 13 paramètres cliniques';

  @override
  String get homeFeatureAiTitle => 'Intelligence artificielle';

  @override
  String get homeFeatureAiBody =>
      'Modèle Random Forest, jeu de données de 834 patients';

  @override
  String get homeFeaturePrivacyTitle => 'Respect de la confidentialité';

  @override
  String get homeFeaturePrivacyBody =>
      'Aucune donnée n’est stockée après l’analyse';

  @override
  String get homeCta => 'Démarrer l’évaluation';

  @override
  String get aboutTitle => 'À propos';

  @override
  String get aboutHeadline => 'Évaluation du risque cardiovasculaire';

  @override
  String get aboutSubheadline =>
      'Une aide à la décision médicale basée sur l’intelligence artificielle';

  @override
  String get aboutBody =>
      'CardioPredict analyse des paramètres cliniques afin d’estimer le risque cardiovasculaire, à partir d’un modèle d’intelligence artificielle construit sur un jeu de données de 834 patients.';

  @override
  String get aboutHighlights =>
      'Évaluation rapide • Résultat immédiat • Utilisation simple';

  @override
  String get aboutHowItWorks => 'Comment ça marche';

  @override
  String get aboutStepInputTitle => 'Saisie des données';

  @override
  String get aboutStepInputBody => 'Saisie des paramètres cliniques essentiels';

  @override
  String get aboutStepAnalysisTitle => 'Analyse par le modèle';

  @override
  String get aboutStepAnalysisBody =>
      'Analyse automatique par un modèle d’intelligence artificielle';

  @override
  String get aboutStepResultTitle => 'Résultats';

  @override
  String get aboutStepResultBody =>
      'Affichage du niveau de risque et des recommandations associées';

  @override
  String get aboutInfoTitle => 'Informations importantes';

  @override
  String get aboutInfoNoStorage => 'Aucune donnée personnelle n’est stockée';

  @override
  String get aboutInfoRealTime => 'Analyse effectuée en temps réel';

  @override
  String get aboutInfoInformative => 'Résultats à usage informatif uniquement';

  @override
  String get aboutInfoConsult => 'Consultez un médecin pour un diagnostic';

  @override
  String get aboutCta => 'Commencer l’évaluation';

  @override
  String get aboutDevelopedBy => 'Développé par';

  @override
  String get aboutContext =>
      'Application développée dans le cadre d’un mémoire de master en Génie Logiciel à l’IFRI/UAC';

  @override
  String get formTitle => 'Évaluation cardiaque';

  @override
  String stepOf(int current, int total) {
    return 'Étape $current sur $total';
  }

  @override
  String get stepDemographicsTitle => 'Informations démographiques';

  @override
  String get stepDemographicsShort => 'Démographie';

  @override
  String get stepDemographicsBody => 'Âge et sexe biologique';

  @override
  String get stepPhysiologyTitle => 'Paramètres physiologiques';

  @override
  String get stepPhysiologyShort => 'Physiologie';

  @override
  String get stepPhysiologyBody => 'Pression artérielle et fréquence cardiaque';

  @override
  String get stepBiologyTitle => 'Analyses biologiques';

  @override
  String get stepBiologyShort => 'Biologie';

  @override
  String get stepBiologyBody => 'Cholestérol et glycémie';

  @override
  String get stepClinicalTitle => 'Données cliniques';

  @override
  String get stepClinicalShort => 'Clinique';

  @override
  String get stepClinicalBody => 'ECG, douleurs thoraciques et tests';

  @override
  String get actionPrevious => 'Précédent';

  @override
  String get actionContinue => 'Continuer';

  @override
  String get actionAnalyze => 'Analyser le risque';

  @override
  String get actionRetry => 'Réessayer';

  @override
  String get unitYears => 'ans';

  @override
  String get unitMmHg => 'mmHg';

  @override
  String get unitBpm => 'bpm';

  @override
  String get unitMgDl => 'mg/dL';

  @override
  String get unitMm => 'mm';

  @override
  String get fieldAge => 'Âge du patient';

  @override
  String get fieldAgeHelp => 'Plage acceptée : 1 – 120 ans';

  @override
  String get fieldRestingBp => 'Pression artérielle au repos';

  @override
  String get fieldRestingBpHelp =>
      'Plage acceptée : 50 – 250 mmHg • Normale : 90–120';

  @override
  String get fieldMaxHr => 'Fréquence cardiaque maximale';

  @override
  String get fieldMaxHrHelp =>
      'Plage acceptée : 50 – 250 bpm • Normale : 60–200';

  @override
  String get fieldCholesterol => 'Cholestérol sérique';

  @override
  String get fieldCholesterolHelp =>
      'Plage acceptée : 50 – 700 mg/dL • Normale : < 200';

  @override
  String get fieldStDepression => 'Dépression du segment ST';

  @override
  String get fieldStDepressionHelp =>
      'Plage acceptée : -5 – 10 mm • Normale : 0–2';

  @override
  String get fieldSex => 'Sexe biologique';

  @override
  String get fieldFastingSugar => 'Glycémie à jeun > 120 mg/dL';

  @override
  String get fieldChestPain => 'Type de douleur thoracique';

  @override
  String get fieldRestingEcg => 'Résultats ECG au repos';

  @override
  String get fieldExerciseAngina => 'Angine induite par l’effort';

  @override
  String get fieldStSlope => 'Pente du segment ST à l’effort';

  @override
  String get fieldThallium => 'Résultat de la scintigraphie au thallium';

  @override
  String get fieldVessels => 'Nombre de vaisseaux colorés (fluoroscopie)';

  @override
  String get optionWoman => 'Femme';

  @override
  String get optionWomanBody => 'Sexe féminin';

  @override
  String get optionMan => 'Homme';

  @override
  String get optionManBody => 'Sexe masculin';

  @override
  String get optionNo => 'Non';

  @override
  String get optionYes => 'Oui';

  @override
  String get optionSugarNoBody => 'Glycémie normale';

  @override
  String get optionSugarYesBody => 'Glycémie élevée';

  @override
  String get optionAnginaNoBody => 'Aucune douleur à l’effort';

  @override
  String get optionAnginaYesBody => 'Douleur présente à l’effort';

  @override
  String get optionPainTypical => 'Angine typique';

  @override
  String get optionPainTypicalBody => 'Douleur caractéristique';

  @override
  String get optionPainAtypical => 'Angine atypique';

  @override
  String get optionPainAtypicalBody => 'Douleur non caractéristique';

  @override
  String get optionPainNonAnginal => 'Douleur non angineuse';

  @override
  String get optionPainNonAnginalBody => 'Douleur non liée au cœur';

  @override
  String get optionPainNone => 'Asymptomatique';

  @override
  String get optionPainNoneBody => 'Aucune douleur';

  @override
  String get optionEcgNormal => 'Normal';

  @override
  String get optionEcgNormalBody => 'ECG normal';

  @override
  String get optionEcgSt => 'Anomalie onde ST-T';

  @override
  String get optionEcgStBody => 'Anomalie détectée';

  @override
  String get optionEcgLvh => 'Hypertrophie ventriculaire';

  @override
  String get optionEcgLvhBody => 'HVG probable';

  @override
  String get optionSlopeUp => 'Ascendante';

  @override
  String get optionSlopeUpBody => 'Pente positive';

  @override
  String get optionSlopeFlat => 'Plate';

  @override
  String get optionSlopeFlatBody => 'Pente nulle';

  @override
  String get optionSlopeDown => 'Descendante';

  @override
  String get optionSlopeDownBody => 'Pente négative';

  @override
  String get optionThalNormal => 'Normal';

  @override
  String get optionThalNormalBody => 'Examen normal';

  @override
  String get optionThalFixed => 'Défaut fixe';

  @override
  String get optionThalFixedBody => 'Anomalie fixe détectée';

  @override
  String get optionThalReversible => 'Défaut réversible';

  @override
  String get optionThalReversibleBody => 'Anomalie réversible';

  @override
  String get optionVessels0Body => 'Aucun vaisseau';

  @override
  String get optionVessels1Body => 'Un vaisseau';

  @override
  String get optionVessels2Body => 'Deux vaisseaux';

  @override
  String get optionVessels3Body => 'Trois vaisseaux';

  @override
  String get errorRequired => 'Ce champ est obligatoire';

  @override
  String get errorInvalidNumber => 'Valeur numérique invalide';

  @override
  String errorMin(String value, String unit) {
    return 'Minimum : $value $unit';
  }

  @override
  String errorMax(String value, String unit) {
    return 'Maximum : $value $unit';
  }

  @override
  String get errorChoiceRequired => 'Veuillez sélectionner une option';

  @override
  String get loadingTitle => 'Analyse en cours…';

  @override
  String get loadingBody =>
      'Le modèle analyse les données saisies pour estimer le risque cardiovasculaire';

  @override
  String get failureTitle => 'L’analyse n’a pas abouti';

  @override
  String get failureNotConfigured =>
      'L’application n’est pas configurée pour joindre le serveur d’analyse. Contactez l’administrateur.';

  @override
  String get failureNoConnection =>
      'Impossible de joindre le serveur. Vérifiez la connexion internet, puis réessayez.';

  @override
  String get failureTimeout =>
      'Le serveur met trop de temps à répondre. Réessayez dans un instant.';

  @override
  String get failureServerUnavailable =>
      'Le serveur d’analyse est momentanément indisponible. Réessayez plus tard.';

  @override
  String get failureRejected =>
      'Le serveur a refusé ces données. Vérifiez les valeurs saisies.';

  @override
  String get failureInvalidResponse =>
      'Le serveur a renvoyé une réponse inattendue. Aucun résultat ne peut être affiché.';

  @override
  String get resultTitle => 'Résultats de l’analyse';

  @override
  String get probabilityLabel => 'Probabilité estimée par le modèle';

  @override
  String get riskVeryLow => 'Risque très faible';

  @override
  String get riskLow => 'Risque faible';

  @override
  String get riskModerate => 'Risque modéré';

  @override
  String get riskHigh => 'Risque élevé';

  @override
  String get riskVeryHigh => 'Risque très élevé';

  @override
  String get riskDescriptionVeryLow =>
      'Probabilité estimée très faible. Bilan annuel recommandé.';

  @override
  String get riskDescriptionLow =>
      'Risque faible détecté. Surveillance médicale régulière.';

  @override
  String get riskDescriptionModerate =>
      'Risque modéré. Consultation médicale dans le mois.';

  @override
  String get riskDescriptionHigh =>
      'Risque élevé. Consultation cardiologique rapide (sous 8 jours).';

  @override
  String get riskDescriptionVeryHigh =>
      'Risque très élevé. Consultation urgente (sous 48 h).';

  @override
  String get verdictUnlikely =>
      'Maladie coronarienne peu probable selon le modèle';

  @override
  String get verdictLikely => 'Maladie coronarienne probable selon le modèle';

  @override
  String get riskScaleTitle => 'Niveau de risque';

  @override
  String get scaleVeryLow => 'Très faible';

  @override
  String get scaleLow => 'Faible';

  @override
  String get scaleModerate => 'Modéré';

  @override
  String get scaleHigh => 'Élevé';

  @override
  String get scaleVeryHigh => 'Très élevé';

  @override
  String get recommendationsTitle => 'Recommandations';

  @override
  String get recommendationsEmpty => 'Aucune recommandation disponible';

  @override
  String get recommendationsLanguageNote =>
      'Les recommandations sont fournies par le serveur et ne sont pas encore traduites.';

  @override
  String get actionNewAssessment => 'Nouvelle analyse';

  @override
  String get actionHome => 'Accueil';
}
