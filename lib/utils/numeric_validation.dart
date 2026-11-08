import 'clinical_fields.dart';

enum NumericError { required, invalid, tooLow, tooHigh }

/// La virgule est acceptée car c'est le séparateur décimal français.
num? parseNumeric(NumericField field, String raw) {
  final text = raw.trim().replaceAll(',', '.');
  return field.isDecimal ? double.tryParse(text) : int.tryParse(text);
}

NumericError? validateNumeric(NumericField field, String raw) {
  if (raw.trim().isEmpty) return NumericError.required;
  final value = parseNumeric(field, raw);
  if (value == null) return NumericError.invalid;
  if (value < field.min) return NumericError.tooLow;
  if (value > field.max) return NumericError.tooHigh;
  return null;
}
