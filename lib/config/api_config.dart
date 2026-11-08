import 'package:flutter/foundation.dart';

/// Adresse de l'API de prédiction, fixée à la compilation.
///
/// Aucune URL de production n'est écrite dans le code : elle arrive par
/// `--dart-define=API_BASE_URL=...` ou `--dart-define-from-file`.
class ApiConfig {
  const ApiConfig._();

  static const String _fromEnvironment = String.fromEnvironment('API_BASE_URL');

  // 10.0.2.2 est l'alias de la machine hôte vu depuis l'émulateur Android.
  static const String _androidEmulatorUrl = 'http://10.0.2.2:5000';
  static const String _localUrl = 'http://localhost:5000';

  static Uri? get baseUri =>
      resolve(rawUrl: _fromEnvironment, isRelease: kReleaseMode, isWeb: kIsWeb);

  /// Renvoie `null` plutôt qu'une URL douteuse : mieux vaut une erreur claire
  /// que des données de santé envoyées en clair ou au mauvais endroit.
  @visibleForTesting
  static Uri? resolve({
    required String rawUrl,
    required bool isRelease,
    required bool isWeb,
  }) {
    final url = rawUrl.trim();
    if (url.isEmpty) {
      if (isRelease) return null;
      return Uri.parse(isWeb ? _localUrl : _androidEmulatorUrl);
    }

    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasAuthority) return null;
    if (uri.scheme != 'https' && (isRelease || uri.scheme != 'http')) {
      return null;
    }
    return uri;
  }
}
