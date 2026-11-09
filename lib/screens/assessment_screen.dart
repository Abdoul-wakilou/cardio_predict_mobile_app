import 'package:flutter/material.dart';

import '../controllers/app_scope.dart';
import '../controllers/assessment_controller.dart';
import '../l10n/generated/app_localizations.dart';
import '../theme/app_theme.dart';
import '../utils/clinical_fields.dart';
import '../utils/clinical_labels.dart';
import '../widgets/choice_input_field.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/language_switch.dart';
import '../widgets/notice_card.dart';
import '../widgets/numeric_input_field.dart';
import '../widgets/step_indicator.dart';
import 'result_screen.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  late final AssessmentController _form;
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _form = AssessmentController(
      service: AppScope.read(context).predictionService,
    );
  }

  @override
  void dispose() {
    _form.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  void _previous() {
    _form.back();
    _scrollToTop();
  }

  Future<void> _primaryAction() async {
    FocusScope.of(context).unfocus();

    if (!_form.isLastStep) {
      if (_form.advance()) _scrollToTop();
      return;
    }

    final languageCode = Localizations.localeOf(context).languageCode;
    final result = await _form.submit(languageCode: languageCode);
    if (!mounted) return;
    if (result == null) {
      _scrollToTop();
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ResultScreen(result: result)),
    );
  }

  Widget _buildField(ClinicalField field) => switch (field) {
    NumericField() => NumericInputField(
      field: field,
      controller: _form.textController(field),
      error: _form.visibleNumericError(field),
    ),
    ChoiceField() => ChoiceInputField(
      field: field,
      selected: _form.choiceOf(field),
      showMissing: _form.isChoiceMissingVisible(field),
      onSelected: (code) => _form.choose(field, code),
    ),
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: _form,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: Text(l10n.formTitle),
          actions: const [
            LanguageSwitch(),
            SizedBox(width: AppSpacing.md),
          ],
        ),
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            child: _form.isSubmitting
                ? const _AnalysisInProgress()
                : _buildForm(l10n),
          ),
        ),
        bottomNavigationBar: _form.isSubmitting ? null : _buildActions(l10n),
      ),
    );
  }

  Widget _buildForm(AppLocalizations l10n) {
    final theme = Theme.of(context);
    final steps = l10n.stepTexts;
    final step = steps[_form.step];
    final failure = _form.failure;

    return ListView(
      key: const ValueKey('assessment-form'),
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      children: [
        StepIndicator(
          labels: [for (final item in steps) item.short],
          current: _form.step,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          l10n.stepOf(_form.step + 1, _form.stepCount),
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(step.title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          step.description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (failure != null) ...[
          // Les saisies sont conservées : réessayer ne demande rien de plus.
          NoticeCard(
            icon: Icons.cloud_off_rounded,
            title: l10n.failureTitle,
            body: l10n.failureMessage(failure),
            isError: true,
            action: TextButton.icon(
              onPressed: _primaryAction,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.actionRetry),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        for (final (index, field) in _form.currentFields.indexed)
          Padding(
            key: ObjectKey(field),
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: FadeSlideIn(order: index, child: _buildField(field)),
          ),
      ],
    );
  }

  Widget _buildActions(AppLocalizations l10n) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        child: Row(
          children: [
            if (_form.step > 0) ...[
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(padding: _actionPadding),
                  onPressed: _previous,
                  child: _SingleLineLabel(l10n.actionPrevious),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              flex: 3,
              child: FilledButton(
                style: FilledButton.styleFrom(padding: _actionPadding),
                onPressed: _primaryAction,
                child: _SingleLineLabel(
                  _form.isLastStep ? l10n.actionAnalyze : l10n.actionContinue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Marges latérales réduites : deux boutons partagent la largeur du téléphone.
const EdgeInsets _actionPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.md,
  vertical: 18,
);

/// Libellé toujours sur une ligne : il rétrécit sur les petits écrans ou avec
/// une grande taille de police système, au lieu de passer à la ligne.
class _SingleLineLabel extends StatelessWidget {
  const _SingleLineLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(text, maxLines: 1, softWrap: false),
    );
  }
}

class _AnalysisInProgress extends StatelessWidget {
  const _AnalysisInProgress();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Center(
      key: const ValueKey('assessment-loading'),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Semantics(
          liveRegion: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 96,
                height: 96,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const SizedBox.expand(
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ),
                    Icon(
                      Icons.favorite_rounded,
                      size: 36,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              FadeSlideIn(
                child: Text(
                  l10n.loadingTitle,
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              FadeSlideIn(
                order: 1,
                child: Text(
                  l10n.loadingBody,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
