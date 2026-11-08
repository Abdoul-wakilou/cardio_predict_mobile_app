import 'package:flutter/services.dart';

import 'clinical_fields.dart';

/// Filtre la saisie numérique d'un champ clinique.
///
/// La virgule devient un point au lieu d'être supprimée : sinon « 0,5 » serait
/// lu « 05 », soit dix fois la valeur réelle, sans qu'aucune erreur n'apparaisse.
class NumericInputFormatter extends TextInputFormatter {
  NumericInputFormatter(NumericField field)
    : _pattern = RegExp(
        field.isDecimal
            ? '^${field.allowsNegative ? '-?' : ''}\\d*\\.?\\d{0,2}\$'
            : '^\\d*\$',
      );

  final RegExp _pattern;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(',', '.');
    if (!_pattern.hasMatch(text)) return oldValue;
    return newValue.copyWith(text: text);
  }
}
