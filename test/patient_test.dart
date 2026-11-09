import 'package:cardio_predict_mobile_app/models/patient.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toJson respecte les noms et l’encodage attendus par l’API', () {
    const patient = Patient(
      age: 55,
      sex: 1,
      chestPain: 3,
      restingBloodPressure: 130,
      cholesterol: 240,
      fastingBloodSugar: 0,
      restingEcg: 2,
      maxHeartRate: 150,
      exerciseAngina: 1,
      stDepression: 1.5,
      stSlope: 1,
      vesselCount: 2,
      thalliumResult: 2,
    );

    expect(patient.toJson(), {
      'age': 55,
      'sex': 1,
      'cp': 3,
      'trestbps': 130,
      'chol': 240,
      'fbs': 0,
      'restecg': 2,
      'thalach': 150,
      'exang': 1,
      'oldpeak': 1.5,
      'slope': 1,
      'ca': 2,
      'thal': 2,
    });
  });
}
