import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Carte commune à tous les champs : libellé, contenu, message d'erreur.
class FieldCard extends StatelessWidget {
  const FieldCard({
    super.key,
    required this.label,
    required this.child,
    this.errorText,
  });

  final String label;
  final Widget child;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.md),
            child,
            if (errorText != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                errorText!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
