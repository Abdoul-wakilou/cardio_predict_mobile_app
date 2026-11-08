import 'package:cardio_predict_mobile_app/config/api_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('en développement, sans URL, vise l’API locale', () {
    expect(
      ApiConfig.resolve(rawUrl: '', isRelease: false, isWeb: false).toString(),
      'http://10.0.2.2:5000',
    );
    expect(
      ApiConfig.resolve(rawUrl: '', isRelease: false, isWeb: true).toString(),
      'http://localhost:5000',
    );
  });

  test('en production, l’URL est obligatoire', () {
    expect(
      ApiConfig.resolve(rawUrl: '', isRelease: true, isWeb: false),
      isNull,
    );
  });

  test('en production, HTTP est refusé', () {
    expect(
      ApiConfig.resolve(
        rawUrl: 'http://api.exemple.org',
        isRelease: true,
        isWeb: false,
      ),
      isNull,
    );
  });

  test('en production, HTTPS est accepté', () {
    expect(
      ApiConfig.resolve(
        rawUrl: 'https://api.exemple.org',
        isRelease: true,
        isWeb: false,
      ).toString(),
      'https://api.exemple.org',
    );
  });

  test('une URL mal formée est refusée', () {
    expect(
      ApiConfig.resolve(rawUrl: 'pas-une-url', isRelease: false, isWeb: false),
      isNull,
    );
    expect(
      ApiConfig.resolve(
        rawUrl: 'ftp://api.exemple.org',
        isRelease: false,
        isWeb: false,
      ),
      isNull,
    );
  });
}
