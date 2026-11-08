/// Niveaux renvoyés par `get_risk_level` côté API, du plus faible au plus élevé.
enum RiskLevel { veryLow, low, moderate, high, veryHigh }

/// Réponse validée de l'API de prédiction.
class PredictionResult {
  const PredictionResult({
    required this.diseaseLikely,
    required this.probabilityDisease,
    required this.riskLevel,
    required this.recommendations,
    required this.recommendationsLanguage,
  });

  /// Lève une [FormatException] dès qu'un champ manque ou se contredit.
  ///
  /// Une réponse incomplète ne doit jamais s'afficher comme un risque nul :
  /// sur un outil médical, le doute doit produire une erreur visible.
  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    final prediction = json['prediction'];
    final level = json['risk_level'];
    final probability = json['probability_disease'];
    final recommendations = json['recommendations'];

    if (prediction is! int || (prediction != 0 && prediction != 1)) {
      throw const FormatException('prediction invalide');
    }
    if (level is! int || level < 0 || level >= RiskLevel.values.length) {
      throw const FormatException('risk_level invalide');
    }
    if (probability is! num || probability < 0 || probability > 1) {
      throw const FormatException('probability_disease invalide');
    }
    if (recommendations is! List) {
      throw const FormatException('recommendations invalide');
    }
    // L'API réserve les niveaux 2 à 4 à la classe « malade ».
    if ((prediction == 1) != (level >= RiskLevel.moderate.index)) {
      throw const FormatException('prediction et risk_level incohérents');
    }

    return PredictionResult(
      diseaseLikely: prediction == 1,
      probabilityDisease: probability.toDouble(),
      riskLevel: RiskLevel.values[level],
      recommendations: recommendations
          .map((item) => item.toString())
          .toList(growable: false),
      // L'API ne rédige aujourd'hui ses recommandations qu'en français.
      recommendationsLanguage: json['language'] as String? ?? 'fr',
    );
  }

  final bool diseaseLikely;
  final double probabilityDisease;
  final RiskLevel riskLevel;
  final List<String> recommendations;
  final String recommendationsLanguage;
}
