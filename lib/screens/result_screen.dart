import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/prediction_result.dart';
import '../theme/app_theme.dart';
import '../utils/clinical_labels.dart';
import '../utils/recommendation_text.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/language_switch.dart';
import '../widgets/notice_card.dart';
import '../widgets/risk_gauge.dart';
import '../widgets/risk_scale.dart';
import 'assessment_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.result});

  final PredictionResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final riskColor = AppColors.risk(result.riskLevel, theme.brightness);
    final percent = NumberFormat.decimalPercentPattern(
      locale: languageCode,
      decimalDigits: 1,
    ).format(result.probabilityDisease);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.resultTitle),
        actions: const [
          LanguageSwitch(),
          SizedBox(width: AppSpacing.md),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          children: [
            FadeSlideIn(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    children: [
                      RiskGauge(
                        value: result.probabilityDisease,
                        color: riskColor,
                        valueText: percent,
                        caption: l10n.probabilityLabel,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        l10n.riskLabel(result.riskLevel),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: riskColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l10n.riskDescription(result.riskLevel),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: riskColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          result.diseaseLikely
                              ? l10n.verdictLikely
                              : l10n.verdictUnlikely,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: riskColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Placé juste sous le résultat pour être lu avant les conseils.
            FadeSlideIn(
              order: 1,
              child: NoticeCard(
                icon: Icons.health_and_safety_outlined,
                title: l10n.disclaimerTitle,
                body: l10n.disclaimerBody,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            FadeSlideIn(
              order: 2,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.riskScaleTitle,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      RiskScale(level: result.riskLevel),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FadeSlideIn(
              order: 3,
              child: Text(
                l10n.recommendationsTitle,
                style: theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (result.recommendations.isNotEmpty &&
                result.recommendationsLanguage != languageCode) ...[
              Text(
                l10n.recommendationsLanguageNote,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            if (result.recommendations.isEmpty)
              Text(l10n.recommendationsEmpty)
            else
              for (final (index, text) in result.recommendations.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: FadeSlideIn(
                    order: 4 + index,
                    child: _RecommendationCard(
                      number: index + 1,
                      text: RecommendationText.parse(text),
                    ),
                  ),
                ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              // La route du formulaire est recréée : aucune donnée du patient
              // précédent ne reste affichée pour le suivant.
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(
                  builder: (_) => const AssessmentScreen(),
                ),
                (route) => route.isFirst,
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.actionNewAssessment),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              icon: const Icon(Icons.home_outlined),
              label: Text(l10n.actionHome),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.number, required this.text});

  final int number;
  final RecommendationText text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 13,
              backgroundColor: scheme.primary.withValues(alpha: 0.12),
              child: Text(
                '$number',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (text.heading != null) ...[
                    Text(text.heading!, style: theme.textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.xs),
                  ],
                  Text(
                    text.body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
