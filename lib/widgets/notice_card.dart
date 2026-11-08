import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Encadré d'information : avertissement médical ou erreur réseau.
class NoticeCard extends StatelessWidget {
  const NoticeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.isError = false,
    this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool isError;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final background = isError
        ? scheme.errorContainer
        : scheme.tertiaryContainer.withValues(alpha: 0.55);
    final foreground = isError
        ? scheme.onErrorContainer
        : scheme.onTertiaryContainer;

    return Semantics(
      container: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: foreground, size: 22),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    body,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: foreground,
                      height: 1.45,
                    ),
                  ),
                  if (action != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    action!,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
