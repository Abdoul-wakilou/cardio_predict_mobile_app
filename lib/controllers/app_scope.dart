import 'package:flutter/widgets.dart';

import '../services/prediction_service.dart';
import 'locale_controller.dart';

/// Met le service et la langue à disposition des écrans sans les passer de
/// constructeur en constructeur.
class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.predictionService,
    required this.localeController,
    required super.child,
  });

  final PredictionService predictionService;
  final LocaleController localeController;

  /// Lecture sans abonnement, donc utilisable dans `initState`.
  static AppScope read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AppScope>()!;

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      predictionService != oldWidget.predictionService ||
      localeController != oldWidget.localeController;
}
