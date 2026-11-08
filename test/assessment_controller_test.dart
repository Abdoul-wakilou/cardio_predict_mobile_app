import 'package:cardio_predict_mobile_app/controllers/assessment_controller.dart';
import 'package:cardio_predict_mobile_app/services/prediction_service.dart';
import 'package:cardio_predict_mobile_app/utils/clinical_fields.dart';
import 'package:cardio_predict_mobile_app/utils/numeric_validation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_prediction_service.dart';

void fillAll(AssessmentController form) {
  const texts = {
    NumericField.age: '55',
    NumericField.restingBloodPressure: '130',
    NumericField.maxHeartRate: '150',
    NumericField.cholesterol: '240',
    NumericField.stDepression: '1,5',
  };
  texts.forEach((field, text) => form.textController(field).text = text);
  for (final field in ChoiceField.values) {
    form.choose(field, field.codes.last);
  }
}

void main() {
  late FakePredictionService service;
  late AssessmentController form;

  setUp(() {
    service = FakePredictionService([sampleResult]);
    form = AssessmentController(service: service);
  });

  test('aucune erreur n’est affichée avant la première tentative', () {
    expect(form.visibleNumericError(NumericField.age), isNull);
    expect(form.isChoiceMissingVisible(ChoiceField.sex), isFalse);
  });

  test('une étape incomplète bloque et révèle ses erreurs', () {
    expect(form.advance(), isFalse);
    expect(form.step, 0);
    expect(form.visibleNumericError(NumericField.age), NumericError.required);
    expect(form.isChoiceMissingVisible(ChoiceField.sex), isTrue);
  });

  test('une valeur hors plage bloque aussi l’étape', () {
    form.textController(NumericField.age).text = '150';
    form.choose(ChoiceField.sex, 1);
    expect(form.advance(), isFalse);
    expect(form.visibleNumericError(NumericField.age), NumericError.tooHigh);
  });

  test('la saisie au clavier notifie l’écran', () {
    var notified = false;
    form.addListener(() => notified = true);
    form.textController(NumericField.stDepression).text = '1';
    expect(notified, isTrue);
  });

  test('soumet les 13 valeurs converties', () async {
    fillAll(form);
    final result = await form.submit(languageCode: 'fr');

    expect(result, sampleResult);
    final patient = service.received.single;
    expect(patient.toJson().length, 13);
    expect(patient.age, 55);
    expect(patient.stDepression, 1.5);
    expect(patient.thalliumResult, 2);
    expect(patient.vesselCount, 3);
  });

  test('un formulaire incomplet n’appelle pas le serveur', () async {
    form.textController(NumericField.age).text = '55';
    form.choose(ChoiceField.sex, 1);

    expect(await form.submit(languageCode: 'fr'), isNull);
    expect(service.received, isEmpty);
    expect(form.step, 1, reason: 'revient à la première étape incomplète');
  });

  test('un échec conserve les saisies et permet de réessayer', () async {
    service = FakePredictionService([
      PredictionErrorKind.timeout,
      sampleResult,
    ]);
    form = AssessmentController(service: service);
    fillAll(form);

    expect(await form.submit(languageCode: 'fr'), isNull);
    expect(form.failure, PredictionErrorKind.timeout);
    expect(form.isSubmitting, isFalse);
    expect(form.textController(NumericField.age).text, '55');

    expect(await form.submit(languageCode: 'fr'), sampleResult);
    expect(form.failure, isNull);
  });
}
