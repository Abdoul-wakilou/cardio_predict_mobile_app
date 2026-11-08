import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Set<String> keysOf(String path) {
  final json =
      jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
  return json.keys.where((key) => !key.startsWith('@')).toSet();
}

void main() {
  test('le français et l’anglais définissent les mêmes textes', () {
    expect(keysOf('lib/l10n/app_en.arb'), keysOf('lib/l10n/app_fr.arb'));
  });
}
