import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/app_theme.dart';
import '../utils/clinical_fields.dart';
import '../utils/clinical_labels.dart';
import 'field_card.dart';

/// Choix en tuiles : toutes les options restent visibles, ce qui évite
/// d'ouvrir une liste déroulante pour chacun des huit champs concernés.
class ChoiceInputField extends StatelessWidget {
  const ChoiceInputField({
    super.key,
    required this.field,
    required this.selected,
    required this.showMissing,
    required this.onSelected,
  });

  final ChoiceField field;
  final int? selected;
  final bool showMissing;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final options = l10n.choiceOptions(field);

    final rows = <Widget>[];
    for (var i = 0; i < options.length; i += 2) {
      if (i > 0) rows.add(const SizedBox(height: AppSpacing.sm));
      final pair = options.skip(i).take(2);
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, option) in pair.indexed) ...[
                if (index > 0) const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _OptionTile(
                    option: option,
                    isSelected: selected == option.code,
                    onTap: () => onSelected(option.code),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return FieldCard(
      label: l10n.choiceLabel(field),
      errorText: showMissing ? l10n.errorChoiceRequired : null,
      child: Column(children: rows),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final ChoiceOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final radius = BorderRadius.circular(AppRadius.sm);

    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isSelected
                  ? scheme.primary.withValues(alpha: 0.1)
                  : scheme.surfaceContainerHighest.withValues(alpha: 0.35),
              borderRadius: radius,
              border: Border.all(
                color: isSelected ? scheme.primary : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? scheme.primary : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        option.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: scheme.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
