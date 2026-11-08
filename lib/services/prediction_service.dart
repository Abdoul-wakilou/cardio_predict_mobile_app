import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/patient.dart';
import '../models/prediction_result.dart';

enum PredictionErrorKind {
  notConfigured,
  noConnection,
  timeout,
  serverUnavailable,
  rejected,
  invalidResponse,
}

/// Ne transporte qu'une catégorie d'erreur : le corps des réponses de l'API
/// peut citer des valeurs du patient, il ne doit ni s'afficher ni se journaliser.
class PredictionException implements Exception {
  const PredictionException(this.kind);

  final PredictionErrorKind kind;

  @override
  String toString() => 'PredictionException(${kind.name})';
}

/// Contrat de prédiction, remplaçable par un faux service dans les tests.
abstract interface class PredictionService {
  Future<PredictionResult> predict(
    Patient patient, {
    required String languageCode,
  });
}

class HttpPredictionService implements PredictionService {
  HttpPredictionService({
    http.Client? client,
    Uri? baseUri,
    this.timeout = const Duration(seconds: 10),
  }) : _client = client ?? http.Client(),
       _baseUri = baseUri ?? ApiConfig.baseUri;

  final http.Client _client;
  final Uri? _baseUri;
  final Duration timeout;

  @override
  Future<PredictionResult> predict(
    Patient patient, {
    required String languageCode,
  }) async {
    final baseUri = _baseUri;
    if (baseUri == null) {
      throw const PredictionException(PredictionErrorKind.notConfigured);
    }

    final http.Response response;
    try {
      response = await _client
          .post(
            // Conserve un éventuel préfixe de chemin (proxy, sous-dossier).
            baseUri.replace(
              path: '${baseUri.path.replaceFirst(RegExp(r'/$'), '')}/predict',
            ),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Accept-Language': languageCode,
            },
            body: jsonEncode(patient.toJson()),
          )
          .timeout(timeout);
    } on TimeoutException {
      throw const PredictionException(PredictionErrorKind.timeout);
    } on http.ClientException {
      throw const PredictionException(PredictionErrorKind.noConnection);
    }

    if (response.statusCode >= 500) {
      throw const PredictionException(PredictionErrorKind.serverUnavailable);
    }
    if (response.statusCode != 200) {
      throw const PredictionException(PredictionErrorKind.rejected);
    }

    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return PredictionResult.fromJson(decoded as Map<String, dynamic>);
    } on FormatException {
      throw const PredictionException(PredictionErrorKind.invalidResponse);
    } on TypeError {
      throw const PredictionException(PredictionErrorKind.invalidResponse);
    }
  }
}
