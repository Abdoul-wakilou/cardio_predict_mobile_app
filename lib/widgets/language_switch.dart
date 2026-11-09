import 'package:flutter/material.dart';

import '../controllers/app_scope.dart';
import '../l10n/generated/app_localizations.dart';
import '../theme/app_theme.dart';

/// Sélecteur FR / EN, accessible depuis chaque écran.
class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key, this.onHero = false});

  /// Vrai lorsque le sélecteur est posé sur le dégradé vert de l'accueil.
  final bool onHero;

  static const List<Locale> _locales = [Locale('fr'), Locale('en')];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final current = Localizations.localeOf(context).languageCode;
    final track = onHero
        ? Colors.white.withValues(alpha: 0.16)
        : scheme.surfaceContainerHighest;
    final selected = onHero ? Colors.white : scheme.primary;
    final selectedText = onHero ? AppColors.brandDeep : scheme.onPrimary;
    final idleText = onHero ? Colors.white : scheme.onSurfaceVariant;

    return Semantics(
      container: true,
      label: AppLocalizations.of(context).languageSwitchLabel,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: track,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final locale in _locales)
              Semantics(
                button: true,
                selected: locale.languageCode == current,
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () =>
                      AppScope.read(context).localeController.select(locale),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: locale.languageCode == current
                          ? selected
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      locale.languageCode.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: locale.languageCode == current
                            ? selectedText
                            : idleText,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
