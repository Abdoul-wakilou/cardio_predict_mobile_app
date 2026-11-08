import 'package:cardio_predict_mobile_app/utils/clinical_fields.dart';
import 'package:cardio_predict_mobile_app/utils/numeric_input_formatter.dart';
import 'package:cardio_predict_mobile_app/utils/numeric_validation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Reproduit une saisie caractère par caractère, comme au clavier.
String type(NumericField field, String keys) {
  final formatter = NumericInputFormatter(field);
  var value = TextEditingValue.empty;
  for (final key in keys.split('')) {
    value = formatter.formatEditUpdate(
      value,
      TextEditingValue(text: value.text + key),
    );
  }
  return value.text;
}

void main() {
  group('validateNumeric', () {
    test('accepte les bornes de FEATURE_RANGES', () {
      const bounds = {
        NumericField.age: ['1', '120'],
        NumericField.restingBloodPressure: ['50', '250'],
        NumericField.maxHeartRate: ['50', '250'],
        NumericField.cholesterol: ['50', '700'],
        NumericField.stDepression: ['-5', '10'],
      };
      bounds.forEach((field, values) {
        for (final value in values) {
          expect(
            validateNumeric(field, value),
            isNull,
            reason: '$field=$value',
          );
        }
      });
    });

    test('refuse les valeurs hors plage', () {
      expect(validateNumeric(NumericField.age, '0'), NumericError.tooLow);
      expect(validateNumeric(NumericField.age, '121'), NumericError.tooHigh);
      expect(
        validateNumeric(NumericField.stDepression, '-5.1'),
        NumericError.tooLow,
      );
      expect(
        validateNumeric(NumericField.cholesterol, '701'),
        NumericError.tooHigh,
      );
    });

    test('signale un champ vide ou illisible', () {
      expect(validateNumeric(NumericField.age, '  '), NumericError.required);
      expect(
        validateNumeric(NumericField.stDepression, '-'),
        NumericError.invalid,
      );
      expect(validateNumeric(NumericField.age, '45.5'), NumericError.invalid);
    });

    test('lit la virgule comme séparateur décimal', () {
      expect(parseNumeric(NumericField.stDepression, '0,5'), 0.5);
    });
  });

  group('NumericInputFormatter', () {
    test('« 0,5 » reste 0.5 et ne devient jamais 05', () {
      expect(type(NumericField.stDepression, '0,5'), '0.5');
    });

    test('garde le signe moins seulement sur la dépression ST', () {
      expect(type(NumericField.stDepression, '-1.5'), '-1.5');
      expect(type(NumericField.age, '-45'), '45');
    });

    test('limite à deux décimales et refuse les lettres', () {
      expect(type(NumericField.stDepression, '1.234'), '1.23');
      expect(type(NumericField.cholesterol, '2a0b0'), '200');
    });
  });
}
