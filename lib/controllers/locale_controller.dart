import 'package:flutter/widgets.dart';

/// Langue choisie dans l'application ; `null` suit la langue du téléphone.
class LocaleController extends ValueNotifier<Locale?> {
  LocaleController() : super(null);

  void select(Locale locale) => value = locale;
}
