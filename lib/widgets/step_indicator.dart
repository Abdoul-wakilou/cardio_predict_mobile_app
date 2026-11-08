import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Frise des étapes : situe le médecin dans le formulaire d'un coup d'œil.
class StepIndicator extends StatelessWidget {
  const StepIndicator({super.key, required this.labels, required this.current});

  final List<String> labels;
  final int current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < labels.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: i == labels.length - 1 ? 0 : AppSpacing.xs,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    height: 5,
                    decoration: BoxDecoration(
                      color: i <= current
                          ? scheme.primary
                          : scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    labels[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: i == current
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: i == current
                          ? scheme.primary
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
