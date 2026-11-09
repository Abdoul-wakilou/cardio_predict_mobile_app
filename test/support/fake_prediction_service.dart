import 'package:cardio_predict_mobile_app/models/patient.dart';
import 'package:cardio_predict_mobile_app/models/prediction_result.dart';
import 'package:cardio_predict_mobile_app/services/prediction_service.dart';

const PredictionResult sampleResult = PredictionResult(
  diseaseLikely: false,
  probabilityDisease: 0.125,
  riskLevel: RiskLevel.veryLow,
  recommendations: ['Âge (55 ans) : bilan cardiovasculaire tous les 2 ans.'],
  recommendationsLanguage: 'fr',
);

/// Faux service : renvoie les réponses prévues, dans l'ordre, sans réseau.
class FakePredictionService implements PredictionService {
  FakePredictionService(this.outcomes);

  /// Chaque élément est un [PredictionResult] ou un [PredictionErrorKind].
  final List<Object> outcomes;
  final List<Patient> received = [];
  final List<String> languages = [];

  @override
  Future<PredictionResult> predict(
    Patient patient, {
    required String languageCode,
  }) async {
    received.add(patient);
    languages.add(languageCode);
    final outcome = outcomes.removeAt(0);
    if (outcome is PredictionErrorKind) throw PredictionException(outcome);
    return outcome as PredictionResult;
  }
}
