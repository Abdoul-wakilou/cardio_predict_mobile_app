import 'package:flutter/material.dart';

import 'controllers/app_scope.dart';
import 'controllers/locale_controller.dart';
import 'l10n/generated/app_localizations.dart';
import 'screens/home_screen.dart';
import 'services/prediction_service.dart';
import 'theme/app_theme.dart';

class CardioPredictApp extends StatefulWidget {
  const CardioPredictApp({super.key, required this.predictionService});

  final PredictionService predictionService;

  @override
  State<CardioPredictApp> createState() => _CardioPredictAppState();
}

class _CardioPredictAppState extends State<CardioPredictApp> {
  final LocaleController _locale = LocaleController();

  @override
  void dispose() {
    _locale.dispose();
    super.dispose();
  }

  // Le public visé étant francophone, le français sert de langue de repli
  // lorsque le téléphone est réglé sur une langue non traduite.
  Locale _resolveLocale(Locale? device, Iterable<Locale> supported) {
    return supported.firstWhere(
      (locale) => locale.languageCode == device?.languageCode,
      orElse: () => const Locale('fr'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      predictionService: widget.predictionService,
      localeController: _locale,
      child: ValueListenableBuilder<Locale?>(
        valueListenable: _locale,
        builder: (context, locale, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          localeResolutionCallback: _resolveLocale,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
