import 'package:flutter/widgets.dart';

import '../models/patient.dart';
import '../models/prediction_result.dart';
import '../services/prediction_service.dart';
import '../utils/clinical_fields.dart';
import '../utils/numeric_validation.dart';

/// État et règles du formulaire, indépendants de l'affichage.
///
/// Les données ne vivent qu'en mémoire, le temps de l'écran : rien n'est écrit
/// sur le téléphone.
class AssessmentController extends ChangeNotifier {
  AssessmentController({required PredictionService service})
    : _service = service {
    for (final field in NumericField.values) {
      // Sans cette écoute, la saisie au clavier ne rafraîchirait pas l'écran.
      _texts[field] = TextEditingController()..addListener(notifyListeners);
    }
  }

  final PredictionService _service;
  final Map<NumericField, TextEditingController> _texts = {};
  final Map<ChoiceField, int> _choices = {};

  // Les erreurs n'apparaissent qu'après une tentative de passage à la suite,
  // pour ne pas accuser le médecin d'un champ qu'il n'a pas encore rempli.
  final Set<int> _attemptedSteps = {};

  int _step = 0;
  bool _isSubmitting = false;
  bool _isDisposed = false;
  PredictionErrorKind? _failure;

  int get step => _step;
  int get stepCount => assessmentSteps.length;
  bool get isLastStep => _step == stepCount - 1;
  bool get isSubmitting => _isSubmitting;
  PredictionErrorKind? get failure => _failure;
  List<ClinicalField> get currentFields => assessmentSteps[_step];

  TextEditingController textController(NumericField field) => _texts[field]!;

  int? choiceOf(ChoiceField field) => _choices[field];

  void choose(ChoiceField field, int code) {
    _choices[field] = code;
    notifyListeners();
  }

  NumericError? visibleNumericError(NumericField field) {
    if (!_attemptedSteps.contains(_step)) return null;
    return validateNumeric(field, _texts[field]!.text);
  }

  bool isChoiceMissingVisible(ChoiceField field) =>
      _attemptedSteps.contains(_step) && !_choices.containsKey(field);

  bool isStepValid(int index) => assessmentSteps[index].every(
    (field) => switch (field) {
      NumericField() => validateNumeric(field, _texts[field]!.text) == null,
      ChoiceField() => _choices.containsKey(field),
    },
  );

  bool get isComplete =>
      List.generate(stepCount, isStepValid).every((valid) => valid);

  /// Passe à l'étape suivante si l'étape courante est valide.
  bool advance() {
    if (!isStepValid(_step)) {
      _attemptedSteps.add(_step);
      notifyListeners();
      return false;
    }
    if (!isLastStep) {
      _step++;
      notifyListeners();
    }
    return true;
  }

  void back() {
    if (_step == 0) return;
    _step--;
    _failure = null;
    notifyListeners();
  }

  /// Renvoie le résultat, ou `null` si le formulaire est incomplet ou si
  /// l'appel a échoué ; dans ce cas [failure] permet de proposer un nouvel essai.
  Future<PredictionResult?> submit({required String languageCode}) async {
    if (_isSubmitting) return null;
    if (!isComplete) {
      _step = List.generate(stepCount, isStepValid).indexOf(false);
      _attemptedSteps.add(_step);
      notifyListeners();
      return null;
    }

    _isSubmitting = true;
    _failure = null;
    notifyListeners();

    PredictionResult? result;
    try {
      result = await _service.predict(
        _buildPatient(),
        languageCode: languageCode,
      );
    } on PredictionException catch (error) {
      _failure = error.kind;
    }

    _isSubmitting = false;
    if (!_isDisposed) notifyListeners();
    return result;
  }

  Patient _buildPatient() {
    int integer(NumericField field) =>
        parseNumeric(field, _texts[field]!.text)!.toInt();

    return Patient(
      age: integer(NumericField.age),
      sex: _choices[ChoiceField.sex]!,
      chestPain: _choices[ChoiceField.chestPain]!,
      restingBloodPressure: integer(NumericField.restingBloodPressure),
      cholesterol: integer(NumericField.cholesterol),
      fastingBloodSugar: _choices[ChoiceField.fastingBloodSugar]!,
      restingEcg: _choices[ChoiceField.restingEcg]!,
      maxHeartRate: integer(NumericField.maxHeartRate),
      exerciseAngina: _choices[ChoiceField.exerciseAngina]!,
      stDepression: parseNumeric(
        NumericField.stDepression,
        _texts[NumericField.stDepression]!.text,
      )!.toDouble(),
      stSlope: _choices[ChoiceField.stSlope]!,
      vesselCount: _choices[ChoiceField.vesselCount]!,
      thalliumResult: _choices[ChoiceField.thalliumResult]!,
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    for (final controller in _texts.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
