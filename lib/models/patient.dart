/// Les 13 variables cliniques attendues par le modèle.
///
/// Tous les champs sont obligatoires : remplacer une valeur absente par 0
/// produirait une prédiction plausible mais fausse.
class Patient {
  const Patient({
    required this.age,
    required this.sex,
    required this.chestPain,
    required this.restingBloodPressure,
    required this.cholesterol,
    required this.fastingBloodSugar,
    required this.restingEcg,
    required this.maxHeartRate,
    required this.exerciseAngina,
    required this.stDepression,
    required this.stSlope,
    required this.vesselCount,
    required this.thalliumResult,
  });

  final int age;
  final int sex;
  final int chestPain;
  final int restingBloodPressure;
  final int cholesterol;
  final int fastingBloodSugar;
  final int restingEcg;
  final int maxHeartRate;
  final int exerciseAngina;
  final double stDepression;
  final int stSlope;
  final int vesselCount;
  final int thalliumResult;

  /// Noms et encodage 0-based du contrat de l'API Flask (`SCHEMA`).
  Map<String, num> toJson() => {
    'age': age,
    'sex': sex,
    'cp': chestPain,
    'trestbps': restingBloodPressure,
    'chol': cholesterol,
    'fbs': fastingBloodSugar,
    'restecg': restingEcg,
    'thalach': maxHeartRate,
    'exang': exerciseAngina,
    'oldpeak': stDepression,
    'slope': stSlope,
    'ca': vesselCount,
    'thal': thalliumResult,
  };
}
