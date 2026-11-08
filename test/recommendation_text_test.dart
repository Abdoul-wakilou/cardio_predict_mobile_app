import 'package:cardio_predict_mobile_app/utils/recommendation_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sépare le constat de la conduite à tenir', () {
    final text = RecommendationText.parse(
      'Hypertension (150 mmHg) : consulter un médecin.',
    );
    expect(text.heading, 'Hypertension (150 mmHg)');
    expect(text.body, 'Consulter un médecin.');
  });

  test('garde le texte entier sans motif reconnu', () {
    const raw = 'Bilan de santé annuel recommandé.';
    final text = RecommendationText.parse(raw);
    expect(text.heading, isNull);
    expect(text.body, raw);
  });
}
