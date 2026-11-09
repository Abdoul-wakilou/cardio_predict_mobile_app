import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/prediction_result.dart';
import '../theme/app_theme.dart';
import '../utils/clinical_labels.dart';

/// Échelle des cinq niveaux, le niveau du patient étant mis en évidence.
class RiskScale extends StatelessWidget {
  const RiskScale({super.key, required this.level});

  final RiskLevel level;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final brightness = theme.brightness;

    return Semantics(
      label: '${l10n.riskScaleTitle} : ${l10n.riskLabel(level)}',
      excludeSemantics: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final candidate in RiskLevel.values)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    Container(
                      height: candidate == level ? 10 : 6,
                      decoration: BoxDecoration(
                        color: AppColors.risk(
                          candidate,
                          brightness,
                        ).withValues(alpha: candidate == level ? 1 : 0.28),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.riskScaleLabel(candidate),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: candidate == level
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: candidate == level
                            ? AppColors.risk(candidate, brightness)
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
