import 'dart:convert';

import 'package:cardio_predict_mobile_app/models/patient.dart';
import 'package:cardio_predict_mobile_app/models/prediction_result.dart';
import 'package:cardio_predict_mobile_app/services/prediction_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const patient = Patient(
  age: 55,
  sex: 1,
  chestPain: 2,
  restingBloodPressure: 130,
  cholesterol: 240,
  fastingBloodSugar: 0,
  restingEcg: 0,
  maxHeartRate: 150,
  exerciseAngina: 0,
  stDepression: 1,
  stSlope: 1,
  vesselCount: 0,
  thalliumResult: 0,
);

final validBody = <String, dynamic>{
  'success': true,
  'prediction': 1,
  'prediction_label': 'Malade',
  'probability_disease': 0.84,
  'probability_no_disease': 0.16,
  'risk_level': 4,
  'risk_label': 'Risque très élevé',
  'risk_description': 'Consultation urgente.',
  'recommendations': ['Âge (55 ans) : bilan tous les 2 ans.'],
};

HttpPredictionService serviceReturning(
  String body, {
  int status = 200,
  Duration timeout = const Duration(seconds: 1),
}) {
  return HttpPredictionService(
    baseUri: Uri.parse('https://api.exemple.org'),
    timeout: timeout,
    client: MockClient(
      (_) async => http.Response.bytes(utf8.encode(body), status),
    ),
  );
}

Matcher failsWith(PredictionErrorKind kind) => throwsA(
  isA<PredictionException>().having((error) => error.kind, 'kind', kind),
);

void main() {
  test('envoie le patient en JSON sur /predict', () async {
    late http.Request captured;
    final service = HttpPredictionService(
      baseUri: Uri.parse('https://api.exemple.org'),
      client: MockClient((request) async {
        captured = request;
        return http.Response.bytes(utf8.encode(jsonEncode(validBody)), 200);
      }),
    );

    await service.predict(patient, languageCode: 'en');

    expect(captured.method, 'POST');
    expect(captured.url.toString(), 'https://api.exemple.org/predict');
    expect(captured.headers['Accept-Language'], 'en');
    expect(jsonDecode(captured.body), patient.toJson());
  });

  test('interprète une réponse valide', () async {
    final result = await serviceReturning(
      jsonEncode(validBody),
    ).predict(patient, languageCode: 'fr');

    expect(result.diseaseLikely, isTrue);
    expect(result.probabilityDisease, 0.84);
    expect(result.riskLevel, RiskLevel.veryHigh);
    expect(result.recommendations, hasLength(1));
  });

  test('accepte une probabilité entière renvoyée sous forme 0 ou 1', () async {
    final body = {...validBody, 'probability_disease': 1};
    final result = await serviceReturning(
      jsonEncode(body),
    ).predict(patient, languageCode: 'fr');
    expect(result.probabilityDisease, 1.0);
  });

  group('une réponse douteuse ne produit jamais de résultat', () {
    for (final field in [
      'prediction',
      'risk_level',
      'probability_disease',
      'recommendations',
    ]) {
      test('champ manquant : $field', () {
        final body = Map<String, dynamic>.of(validBody)..remove(field);
        expect(
          serviceReturning(
            jsonEncode(body),
          ).predict(patient, languageCode: 'fr'),
          failsWith(PredictionErrorKind.invalidResponse),
        );
      });
    }

    test('niveau de risque hors échelle', () {
      final body = {...validBody, 'risk_level': 5};
      expect(
        serviceReturning(jsonEncode(body)).predict(patient, languageCode: 'fr'),
        failsWith(PredictionErrorKind.invalidResponse),
      );
    });

    test('probabilité hors de [0, 1]', () {
      final body = {...validBody, 'probability_disease': 1.2};
      expect(
        serviceReturning(jsonEncode(body)).predict(patient, languageCode: 'fr'),
        failsWith(PredictionErrorKind.invalidResponse),
      );
    });

    test('classe et niveau contradictoires', () {
      final body = {...validBody, 'prediction': 0};
      expect(
        serviceReturning(jsonEncode(body)).predict(patient, languageCode: 'fr'),
        failsWith(PredictionErrorKind.invalidResponse),
      );
    });

    test('corps qui n’est pas du JSON', () {
      expect(
        serviceReturning('<html>').predict(patient, languageCode: 'fr'),
        failsWith(PredictionErrorKind.invalidResponse),
      );
    });

    test('JSON qui n’est pas un objet', () {
      expect(
        serviceReturning('[1, 2]').predict(patient, languageCode: 'fr'),
        failsWith(PredictionErrorKind.invalidResponse),
      );
    });
  });

  group('erreurs réseau', () {
    test('erreur 500 : serveur indisponible', () {
      expect(
        serviceReturning(
          '{"error": "boom"}',
          status: 500,
        ).predict(patient, languageCode: 'fr'),
        failsWith(PredictionErrorKind.serverUnavailable),
      );
    });

    test('erreur 400 : données refusées', () {
      expect(
        serviceReturning(
          '{"error": "age=999 hors plage"}',
          status: 400,
        ).predict(patient, languageCode: 'fr'),
        failsWith(PredictionErrorKind.rejected),
      );
    });

    test('erreur 429 : trop de requêtes', () {
      expect(
        serviceReturning(
          '{"error": "Trop de requêtes."}',
          status: 429,
        ).predict(patient, languageCode: 'fr'),
        failsWith(PredictionErrorKind.rateLimited),
      );
    });

    test('pas de connexion', () {
      final service = HttpPredictionService(
        baseUri: Uri.parse('https://api.exemple.org'),
        client: MockClient((_) => throw http.ClientException('hors ligne')),
      );
      expect(
        service.predict(patient, languageCode: 'fr'),
        failsWith(PredictionErrorKind.noConnection),
      );
    });

    test('délai dépassé', () {
      final service = HttpPredictionService(
        baseUri: Uri.parse('https://api.exemple.org'),
        timeout: const Duration(milliseconds: 10),
        client: MockClient((_) async {
          await Future<void>.delayed(const Duration(seconds: 1));
          return http.Response('{}', 200);
        }),
      );
      expect(
        service.predict(patient, languageCode: 'fr'),
        failsWith(PredictionErrorKind.timeout),
      );
    });

    test('l’erreur ne révèle aucune donnée de la réponse', () async {
      try {
        await serviceReturning(
          '{"error": "age=999 hors plage"}',
          status: 400,
        ).predict(patient, languageCode: 'fr');
        fail('une exception était attendue');
      } on PredictionException catch (error) {
        expect(error.toString(), isNot(contains('999')));
      }
    });
  });
}
