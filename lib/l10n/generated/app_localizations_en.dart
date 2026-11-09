// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CardioPredict';

  @override
  String get languageSwitchLabel => 'App language';

  @override
  String get disclaimerTitle => 'Medical disclaimer';

  @override
  String get disclaimerBody =>
      'CardioPredict is a decision-support tool and does not make a diagnosis. This result is a statistical estimate: it must be interpreted by a healthcare professional, together with the full clinical record.';

  @override
  String get disclaimerShort =>
      'Decision-support tool. It does not replace a healthcare professional\'s judgement.';

  @override
  String get homeTagline =>
      'Decision support to estimate your patients\' cardiovascular risk';

  @override
  String get homeFeatureClinicalTitle => 'Advanced clinical analysis';

  @override
  String get homeFeatureClinicalBody => 'Based on 13 clinical parameters';

  @override
  String get homeFeatureAiTitle => 'Artificial intelligence';

  @override
  String get homeFeatureAiBody => 'Model built on a dataset of 834 patients';

  @override
  String get homeFeaturePrivacyTitle => 'Privacy first';

  @override
  String get homeFeaturePrivacyBody => 'No data is stored after the analysis';

  @override
  String get homeCta => 'Start the assessment';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutHeadline => 'Cardiovascular risk assessment';

  @override
  String get aboutSubheadline =>
      'Medical decision support powered by artificial intelligence';

  @override
  String get aboutBody =>
      'CardioPredict analyses clinical parameters to estimate cardiovascular risk, using an artificial intelligence model built on a dataset of 834 patients.';

  @override
  String get aboutHighlights =>
      'Quick assessment • Immediate result • Simple to use';

  @override
  String get aboutHowItWorks => 'How it works';

  @override
  String get aboutStepInputTitle => 'Data entry';

  @override
  String get aboutStepInputBody => 'Enter the essential clinical parameters';

  @override
  String get aboutStepAnalysisTitle => 'Model analysis';

  @override
  String get aboutStepAnalysisBody =>
      'Automatic analysis by an artificial intelligence model';

  @override
  String get aboutStepResultTitle => 'Results';

  @override
  String get aboutStepResultBody =>
      'Risk level and associated recommendations are displayed';

  @override
  String get aboutInfoTitle => 'Important information';

  @override
  String get aboutInfoNoStorage => 'No personal data is stored';

  @override
  String get aboutInfoRealTime => 'Analysis performed in real time';

  @override
  String get aboutInfoInformative => 'Results are for information only';

  @override
  String get aboutInfoConsult => 'See a doctor for a diagnosis';

  @override
  String get aboutCta => 'Begin the assessment';

  @override
  String get aboutDevelopedBy => 'Developed by';

  @override
  String get aboutContext =>
      'Developed as part of a Master\'s thesis in Software Engineering at IFRI/UAC';

  @override
  String get formTitle => 'Cardiac assessment';

  @override
  String stepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get stepDemographicsTitle => 'Demographic information';

  @override
  String get stepDemographicsShort => 'Demographics';

  @override
  String get stepDemographicsBody => 'Age and biological sex';

  @override
  String get stepPhysiologyTitle => 'Physiological parameters';

  @override
  String get stepPhysiologyShort => 'Physiology';

  @override
  String get stepPhysiologyBody => 'Blood pressure and heart rate';

  @override
  String get stepBiologyTitle => 'Laboratory tests';

  @override
  String get stepBiologyShort => 'Laboratory';

  @override
  String get stepBiologyBody => 'Cholesterol and blood sugar';

  @override
  String get stepClinicalTitle => 'Clinical data';

  @override
  String get stepClinicalShort => 'Clinical';

  @override
  String get stepClinicalBody => 'ECG, chest pain and tests';

  @override
  String get actionPrevious => 'Back';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionAnalyze => 'Analyse the risk';

  @override
  String get actionRetry => 'Try again';

  @override
  String get unitYears => 'years';

  @override
  String get unitMmHg => 'mmHg';

  @override
  String get unitBpm => 'bpm';

  @override
  String get unitMgDl => 'mg/dL';

  @override
  String get unitMm => 'mm';

  @override
  String get fieldAge => 'Patient age';

  @override
  String get fieldAgeHelp => 'Accepted range: 18 – 120 years';

  @override
  String get fieldRestingBp => 'Resting blood pressure';

  @override
  String get fieldRestingBpHelp =>
      'Accepted range: 50 – 250 mmHg • Normal: 90–120';

  @override
  String get fieldMaxHr => 'Maximum heart rate';

  @override
  String get fieldMaxHrHelp => 'Accepted range: 50 – 250 bpm • Normal: 60–200';

  @override
  String get fieldCholesterol => 'Serum cholesterol';

  @override
  String get fieldCholesterolHelp =>
      'Accepted range: 50 – 700 mg/dL • Normal: < 200';

  @override
  String get fieldStDepression => 'ST segment depression';

  @override
  String get fieldStDepressionHelp =>
      'Accepted range: -5 – 10 mm • Normal: 0–2';

  @override
  String get fieldSex => 'Biological sex';

  @override
  String get fieldFastingSugar => 'Fasting blood sugar > 120 mg/dL';

  @override
  String get fieldChestPain => 'Chest pain type';

  @override
  String get fieldRestingEcg => 'Resting ECG results';

  @override
  String get fieldExerciseAngina => 'Exercise-induced angina';

  @override
  String get fieldStSlope => 'ST segment slope during exercise';

  @override
  String get fieldThallium => 'Thallium scintigraphy result';

  @override
  String get fieldVessels => 'Number of coloured vessels (fluoroscopy)';

  @override
  String get optionWoman => 'Female';

  @override
  String get optionWomanBody => 'Female sex';

  @override
  String get optionMan => 'Male';

  @override
  String get optionManBody => 'Male sex';

  @override
  String get optionNo => 'No';

  @override
  String get optionYes => 'Yes';

  @override
  String get optionSugarNoBody => 'Normal blood sugar';

  @override
  String get optionSugarYesBody => 'High blood sugar';

  @override
  String get optionAnginaNoBody => 'No pain on exertion';

  @override
  String get optionAnginaYesBody => 'Pain present on exertion';

  @override
  String get optionPainTypical => 'Typical angina';

  @override
  String get optionPainTypicalBody => 'Characteristic pain';

  @override
  String get optionPainAtypical => 'Atypical angina';

  @override
  String get optionPainAtypicalBody => 'Non-characteristic pain';

  @override
  String get optionPainNonAnginal => 'Non-anginal pain';

  @override
  String get optionPainNonAnginalBody => 'Pain unrelated to the heart';

  @override
  String get optionPainNone => 'Asymptomatic';

  @override
  String get optionPainNoneBody => 'No pain';

  @override
  String get optionEcgNormal => 'Normal';

  @override
  String get optionEcgNormalBody => 'Normal ECG';

  @override
  String get optionEcgSt => 'ST-T wave abnormality';

  @override
  String get optionEcgStBody => 'Abnormality detected';

  @override
  String get optionEcgLvh => 'Ventricular hypertrophy';

  @override
  String get optionEcgLvhBody => 'Probable LVH';

  @override
  String get optionSlopeUp => 'Upsloping';

  @override
  String get optionSlopeUpBody => 'Positive slope';

  @override
  String get optionSlopeFlat => 'Flat';

  @override
  String get optionSlopeFlatBody => 'No slope';

  @override
  String get optionSlopeDown => 'Downsloping';

  @override
  String get optionSlopeDownBody => 'Negative slope';

  @override
  String get optionThalNormal => 'Normal';

  @override
  String get optionThalNormalBody => 'Normal scan';

  @override
  String get optionThalFixed => 'Fixed defect';

  @override
  String get optionThalFixedBody => 'Fixed abnormality detected';

  @override
  String get optionThalReversible => 'Reversible defect';

  @override
  String get optionThalReversibleBody => 'Reversible abnormality';

  @override
  String get optionVessels0Body => 'No vessels';

  @override
  String get optionVessels1Body => 'One vessel';

  @override
  String get optionVessels2Body => 'Two vessels';

  @override
  String get optionVessels3Body => 'Three vessels';

  @override
  String get errorRequired => 'This field is required';

  @override
  String get errorInvalidNumber => 'Invalid numeric value';

  @override
  String errorMin(String value, String unit) {
    return 'Minimum: $value $unit';
  }

  @override
  String errorMax(String value, String unit) {
    return 'Maximum: $value $unit';
  }

  @override
  String get errorChoiceRequired => 'Please select an option';

  @override
  String get loadingTitle => 'Analysing…';

  @override
  String get loadingBody =>
      'The model is analysing the entered data to estimate cardiovascular risk';

  @override
  String get failureTitle => 'The analysis could not be completed';

  @override
  String get failureNotConfigured =>
      'The app is not configured to reach the analysis server. Please contact the administrator.';

  @override
  String get failureNoConnection =>
      'Unable to reach the server. Check the internet connection, then try again.';

  @override
  String get failureTimeout =>
      'The server is taking too long to respond. Please try again in a moment.';

  @override
  String get failureServerUnavailable =>
      'The analysis server is temporarily unavailable. Please try again later.';

  @override
  String get failureRejected =>
      'The server rejected these data. Please check the entered values.';

  @override
  String get failureRateLimited =>
      'Too many requests were sent. Please try again in a moment.';

  @override
  String get failureInvalidResponse =>
      'The server returned an unexpected response. No result can be displayed.';

  @override
  String get resultTitle => 'Analysis results';

  @override
  String get probabilityLabel => 'Probability estimated by the model';

  @override
  String get riskVeryLow => 'Very low risk';

  @override
  String get riskLow => 'Low risk';

  @override
  String get riskModerate => 'Moderate risk';

  @override
  String get riskHigh => 'High risk';

  @override
  String get riskVeryHigh => 'Very high risk';

  @override
  String get riskDescriptionVeryLow =>
      'Very low probability according to the model. Annual check-up advised.';

  @override
  String get riskDescriptionLow =>
      'Low probability according to the model. Regular medical follow-up.';

  @override
  String get riskDescriptionModerate =>
      'Moderate risk according to the model. Consultation within the month.';

  @override
  String get riskDescriptionHigh =>
      'High risk according to the model. Cardiology consultation within 8 days.';

  @override
  String get riskDescriptionVeryHigh =>
      'Very high risk according to the model. Urgent medical consultation within 48 hours.';

  @override
  String get verdictUnlikely =>
      'Coronary disease unlikely according to the model';

  @override
  String get verdictLikely => 'Coronary disease likely according to the model';

  @override
  String get riskScaleTitle => 'Risk level';

  @override
  String get scaleVeryLow => 'Very low';

  @override
  String get scaleLow => 'Low';

  @override
  String get scaleModerate => 'Moderate';

  @override
  String get scaleHigh => 'High';

  @override
  String get scaleVeryHigh => 'Very high';

  @override
  String get recommendationsTitle => 'Recommendations';

  @override
  String get recommendationsEmpty => 'No recommendations available';

  @override
  String get recommendationsLanguageNote =>
      'Recommendations come from the server and are currently available in French only.';

  @override
  String get actionNewAssessment => 'New analysis';

  @override
  String get actionHome => 'Home';
}
