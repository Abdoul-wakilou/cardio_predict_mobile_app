/// Champ du formulaire : valeur numérique saisie ou choix dans une liste.
sealed class ClinicalField {}

/// Bornes identiques à `SCHEMA` dans `api/validation.py`. L'application les
/// vérifie pour le confort du médecin ; la vraie validation reste côté serveur.
enum NumericField implements ClinicalField {
  age(min: 18, max: 120),
  restingBloodPressure(min: 50, max: 250),
  maxHeartRate(min: 50, max: 250),
  cholesterol(min: 50, max: 700),
  stDepression(min: -5, max: 10, isDecimal: true, allowsNegative: true);

  const NumericField({
    required this.min,
    required this.max,
    this.isDecimal = false,
    this.allowsNegative = false,
  });

  final num min;
  final num max;
  final bool isDecimal;
  final bool allowsNegative;
}

/// Les codes reprennent l'encodage 0-based des données d'entraînement.
enum ChoiceField implements ClinicalField {
  sex([0, 1]),
  fastingBloodSugar([0, 1]),
  chestPain([0, 1, 2, 3]),
  restingEcg([0, 1, 2]),
  exerciseAngina([0, 1]),
  stSlope([0, 1, 2]),
  thalliumResult([0, 1, 2]),
  vesselCount([0, 1, 2, 3]);

  const ChoiceField(this.codes);

  final List<int> codes;
}

/// Répartition des 13 variables dans les quatre étapes du formulaire.
const List<List<ClinicalField>> assessmentSteps = [
  [NumericField.age, ChoiceField.sex],
  [NumericField.restingBloodPressure, NumericField.maxHeartRate],
  [NumericField.cholesterol, ChoiceField.fastingBloodSugar],
  [
    ChoiceField.chestPain,
    ChoiceField.restingEcg,
    ChoiceField.exerciseAngina,
    NumericField.stDepression,
    ChoiceField.stSlope,
    ChoiceField.thalliumResult,
    ChoiceField.vesselCount,
  ],
];
