import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/prediction_result.dart';
import '../services/prediction_service.dart';
import 'clinical_fields.dart';

class ChoiceOption {
  const ChoiceOption({
    required this.code,
    required this.label,
    required this.description,
  });

  final int code;
  final String label;
  final String description;
}

class StepText {
  const StepText(this.title, this.short, this.description, this.icon);

  final String title;
  final String short;
  final String description;
  final IconData icon;
}

/// Traduit les identifiants métier en textes affichés, pour que la logique
/// du formulaire reste indépendante de la langue.
extension ClinicalLabels on AppLocalizations {
  List<StepText> get stepTexts => [
    StepText(
      stepDemographicsTitle,
      stepDemographicsShort,
      stepDemographicsBody,
      Icons.person_outline_rounded,
    ),
    StepText(
      stepPhysiologyTitle,
      stepPhysiologyShort,
      stepPhysiologyBody,
      Icons.favorite_border_rounded,
    ),
    StepText(
      stepBiologyTitle,
      stepBiologyShort,
      stepBiologyBody,
      Icons.bloodtype_outlined,
    ),
    StepText(
      stepClinicalTitle,
      stepClinicalShort,
      stepClinicalBody,
      Icons.medical_services_outlined,
    ),
  ];

  String numericLabel(NumericField field) => switch (field) {
    NumericField.age => fieldAge,
    NumericField.restingBloodPressure => fieldRestingBp,
    NumericField.maxHeartRate => fieldMaxHr,
    NumericField.cholesterol => fieldCholesterol,
    NumericField.stDepression => fieldStDepression,
  };

  String numericHelp(NumericField field) => switch (field) {
    NumericField.age => fieldAgeHelp,
    NumericField.restingBloodPressure => fieldRestingBpHelp,
    NumericField.maxHeartRate => fieldMaxHrHelp,
    NumericField.cholesterol => fieldCholesterolHelp,
    NumericField.stDepression => fieldStDepressionHelp,
  };

  String numericUnit(NumericField field) => switch (field) {
    NumericField.age => unitYears,
    NumericField.restingBloodPressure => unitMmHg,
    NumericField.maxHeartRate => unitBpm,
    NumericField.cholesterol => unitMgDl,
    NumericField.stDepression => unitMm,
  };

  String choiceLabel(ChoiceField field) => switch (field) {
    ChoiceField.sex => fieldSex,
    ChoiceField.fastingBloodSugar => fieldFastingSugar,
    ChoiceField.chestPain => fieldChestPain,
    ChoiceField.restingEcg => fieldRestingEcg,
    ChoiceField.exerciseAngina => fieldExerciseAngina,
    ChoiceField.stSlope => fieldStSlope,
    ChoiceField.thalliumResult => fieldThallium,
    ChoiceField.vesselCount => fieldVessels,
  };

  List<ChoiceOption> choiceOptions(ChoiceField field) {
    ChoiceOption option(int code, String label, String description) =>
        ChoiceOption(code: code, label: label, description: description);

    return switch (field) {
      ChoiceField.sex => [
        option(0, optionWoman, optionWomanBody),
        option(1, optionMan, optionManBody),
      ],
      ChoiceField.fastingBloodSugar => [
        option(0, optionNo, optionSugarNoBody),
        option(1, optionYes, optionSugarYesBody),
      ],
      ChoiceField.chestPain => [
        option(0, optionPainTypical, optionPainTypicalBody),
        option(1, optionPainAtypical, optionPainAtypicalBody),
        option(2, optionPainNonAnginal, optionPainNonAnginalBody),
        option(3, optionPainNone, optionPainNoneBody),
      ],
      ChoiceField.restingEcg => [
        option(0, optionEcgNormal, optionEcgNormalBody),
        option(1, optionEcgSt, optionEcgStBody),
        option(2, optionEcgLvh, optionEcgLvhBody),
      ],
      ChoiceField.exerciseAngina => [
        option(0, optionNo, optionAnginaNoBody),
        option(1, optionYes, optionAnginaYesBody),
      ],
      ChoiceField.stSlope => [
        option(0, optionSlopeUp, optionSlopeUpBody),
        option(1, optionSlopeFlat, optionSlopeFlatBody),
        option(2, optionSlopeDown, optionSlopeDownBody),
      ],
      ChoiceField.thalliumResult => [
        option(0, optionThalNormal, optionThalNormalBody),
        option(1, optionThalFixed, optionThalFixedBody),
        option(2, optionThalReversible, optionThalReversibleBody),
      ],
      ChoiceField.vesselCount => [
        option(0, '0', optionVessels0Body),
        option(1, '1', optionVessels1Body),
        option(2, '2', optionVessels2Body),
        option(3, '3', optionVessels3Body),
      ],
    };
  }

  String riskLabel(RiskLevel level) => switch (level) {
    RiskLevel.veryLow => riskVeryLow,
    RiskLevel.low => riskLow,
    RiskLevel.moderate => riskModerate,
    RiskLevel.high => riskHigh,
    RiskLevel.veryHigh => riskVeryHigh,
  };

  String riskDescription(RiskLevel level) => switch (level) {
    RiskLevel.veryLow => riskDescriptionVeryLow,
    RiskLevel.low => riskDescriptionLow,
    RiskLevel.moderate => riskDescriptionModerate,
    RiskLevel.high => riskDescriptionHigh,
    RiskLevel.veryHigh => riskDescriptionVeryHigh,
  };

  String riskScaleLabel(RiskLevel level) => switch (level) {
    RiskLevel.veryLow => scaleVeryLow,
    RiskLevel.low => scaleLow,
    RiskLevel.moderate => scaleModerate,
    RiskLevel.high => scaleHigh,
    RiskLevel.veryHigh => scaleVeryHigh,
  };

  String failureMessage(PredictionErrorKind kind) => switch (kind) {
    PredictionErrorKind.notConfigured => failureNotConfigured,
    PredictionErrorKind.noConnection => failureNoConnection,
    PredictionErrorKind.timeout => failureTimeout,
    PredictionErrorKind.serverUnavailable => failureServerUnavailable,
    PredictionErrorKind.rejected => failureRejected,
    PredictionErrorKind.invalidResponse => failureInvalidResponse,
  };
}
