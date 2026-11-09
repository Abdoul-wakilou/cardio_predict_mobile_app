import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/app_theme.dart';
import '../utils/clinical_fields.dart';
import '../utils/clinical_labels.dart';
import '../utils/numeric_input_formatter.dart';
import '../utils/numeric_validation.dart';
import 'field_card.dart';

class NumericInputField extends StatelessWidget {
  const NumericInputField({
    super.key,
    required this.field,
    required this.controller,
    required this.error,
  });

  final NumericField field;
  final TextEditingController controller;
  final NumericError? error;

  String? _errorText(AppLocalizations l10n) {
    final unit = l10n.numericUnit(field);
    return switch (error) {
      null => null,
      NumericError.required => l10n.errorRequired,
      NumericError.invalid => l10n.errorInvalidNumber,
      NumericError.tooLow => l10n.errorMin('${field.min}', unit),
      NumericError.tooHigh => l10n.errorMax('${field.max}', unit),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final errorText = _errorText(l10n);

    return FieldCard(
      label: l10n.numericLabel(field),
      errorText: errorText,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            key: ValueKey(field),
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(
              decimal: field.isDecimal,
              signed: field.allowsNegative,
            ),
            textInputAction: TextInputAction.next,
            inputFormatters: [NumericInputFormatter(field)],
            decoration: InputDecoration(
              // suffixText disparaît quand le champ est vide ; or l'unité doit
              // rester visible avant la saisie pour éviter toute confusion.
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: AppSpacing.lg),
                child: Text(
                  l10n.numericUnit(field),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              suffixIconConstraints: const BoxConstraints(),
              enabledBorder: errorText == null
                  ? null
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.error),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.numericHelp(field),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
