import 'package:flutter/material.dart';

/// Apparition discrète et échelonnée des blocs d'un écran.
///
/// Respecte le réglage système « réduire les animations ».
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({super.key, required this.child, this.order = 0});

  final Widget child;

  /// Rang d'apparition dans l'écran : chaque rang décale le départ.
  final int order;

  static const int _baseMs = 420;
  static const int _stepMs = 70;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;

    final delay = order * _stepMs;
    final total = _baseMs + delay;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: total),
      curve: Interval(delay / total, 1, curve: Curves.easeOutCubic),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 14 * (1 - value)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
