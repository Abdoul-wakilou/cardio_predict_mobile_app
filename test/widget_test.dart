import 'package:cardio_predict_mobile_app/app.dart';
import 'package:cardio_predict_mobile_app/models/prediction_result.dart';
import 'package:cardio_predict_mobile_app/services/prediction_service.dart';
import 'package:cardio_predict_mobile_app/utils/clinical_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_prediction_service.dart';

Future<void> pumpApp(WidgetTester tester, PredictionService service) async {
  // Écran très haut : tous les champs d'une étape sont construits à la fois.
  tester.view.physicalSize = const Size(1200, 6000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  // Le public visé est francophone : les parcours partent du français.
  tester.platformDispatcher.localesTestValue = const [Locale('fr')];
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);
  await tester.pumpWidget(CardioPredictApp(predictionService: service));
  await tester.pumpAndSettle();
}

Future<void> tapText(WidgetTester tester, String text) async {
  await tester.tap(find.text(text).first);
  await tester.pumpAndSettle();
}

Future<void> enter(WidgetTester tester, NumericField field, String text) =>
    tester.enterText(find.byKey(ValueKey(field)), text);

Future<void> openForm(WidgetTester tester) async {
  await tapText(tester, 'Démarrer l’évaluation');
  await tapText(tester, 'Commencer l’évaluation');
}

Future<void> fillForm(WidgetTester tester) async {
  await enter(tester, NumericField.age, '55');
  await tapText(tester, 'Homme');
  await tapText(tester, 'Continuer');

  await enter(tester, NumericField.restingBloodPressure, '130');
  await enter(tester, NumericField.maxHeartRate, '150');
  await tapText(tester, 'Continuer');

  await enter(tester, NumericField.cholesterol, '240');
  await tapText(tester, 'Non');
  await tapText(tester, 'Continuer');

  await tapText(tester, 'Asymptomatique');
  await tapText(tester, 'Normal');
  await tapText(tester, 'Non');
  await enter(tester, NumericField.stDepression, '1,5');
  await tapText(tester, 'Plate');
  await tapText(tester, 'Défaut réversible');
  await tapText(tester, '0');
}

void main() {
  testWidgets('parcours complet jusqu’au résultat', (tester) async {
    final service = FakePredictionService([sampleResult]);
    await pumpApp(tester, service);
    await openForm(tester);
    await fillForm(tester);
    await tapText(tester, 'Analyser le risque');

    expect(find.text('Risque très faible'), findsOneWidget);
    expect(
      find.text('Maladie coronarienne peu probable selon le modèle'),
      findsOneWidget,
    );
    expect(find.text('Avertissement médical'), findsOneWidget);
    expect(service.received.single.stDepression, 1.5);
    expect(service.languages.single, 'fr');
  });

  testWidgets('une étape vide affiche les erreurs sans avancer', (
    tester,
  ) async {
    await pumpApp(tester, FakePredictionService([]));
    await openForm(tester);
    await tapText(tester, 'Continuer');

    expect(find.text('Ce champ est obligatoire'), findsOneWidget);
    expect(find.text('Veuillez sélectionner une option'), findsOneWidget);
    expect(find.text('Étape 1 sur 4'), findsOneWidget);
  });

  testWidgets('une erreur réseau propose de réessayer', (tester) async {
    await pumpApp(
      tester,
      FakePredictionService([PredictionErrorKind.noConnection, sampleResult]),
    );
    await openForm(tester);
    await fillForm(tester);
    await tapText(tester, 'Analyser le risque');

    expect(find.text('L’analyse n’a pas abouti'), findsOneWidget);
    await tapText(tester, 'Réessayer');
    expect(find.text('Risque très faible'), findsOneWidget);
  });

  testWidgets('l’interface passe en anglais et le signale au serveur', (
    tester,
  ) async {
    final service = FakePredictionService([sampleResult]);
    await pumpApp(tester, service);

    await tapText(tester, 'EN');
    expect(find.text('Start the assessment'), findsOneWidget);
    await tapText(tester, 'FR');
    await openForm(tester);
    await fillForm(tester);
    await tapText(tester, 'EN');
    await tapText(tester, 'Analyse the risk');

    expect(find.text('Very low risk'), findsOneWidget);
    expect(find.textContaining('available in French only'), findsOneWidget);
    expect(service.languages.single, 'en');
  });

  testWidgets('les niveaux élevés restent signalés', (tester) async {
    const high = PredictionResult(
      diseaseLikely: true,
      probabilityDisease: 0.84,
      riskLevel: RiskLevel.veryHigh,
      recommendations: [],
      recommendationsLanguage: 'fr',
    );
    await pumpApp(tester, FakePredictionService([high]));
    await openForm(tester);
    await fillForm(tester);
    await tapText(tester, 'Analyser le risque');

    expect(find.text('Risque très élevé'), findsOneWidget);
    expect(
      find.text('Maladie coronarienne probable selon le modèle'),
      findsOneWidget,
    );
    expect(find.text('Aucune recommandation disponible'), findsOneWidget);
  });
}
