import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Jauge demi-circulaire de la probabilité estimée.
class RiskGauge extends StatelessWidget {
  const RiskGauge({
    super.key,
    required this.value,
    required this.color,
    required this.valueText,
    required this.caption,
  });

  /// Probabilité entre 0 et 1.
  final double value;
  final Color color;
  final String valueText;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final track = theme.colorScheme.surfaceContainerHighest;
    final animate = !MediaQuery.disableAnimationsOf(context);

    return Semantics(
      label: '$caption : $valueText',
      excludeSemantics: true,
      child: SizedBox(
        width: 240,
        height: 136,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: animate ? 0 : value, end: value),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (context, animated, _) =>
                    CustomPaint(painter: _GaugePainter(animated, color, track)),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  valueText,
                  style: theme.textTheme.headlineMedium?.copyWith(color: color),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 44),
                  child: Text(
                    caption,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  const _GaugePainter(this.value, this.color, this.track);

  final double value;
  final Color color;
  final Color track;

  static const double _stroke = 16;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2 - _stroke / 2;
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, radius + _stroke / 2),
      radius: radius,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, math.pi, math.pi, false, paint..color = track);
    if (value > 0) {
      canvas.drawArc(
        rect,
        math.pi,
        math.pi * value.clamp(0.0, 1.0),
        false,
        paint..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) =>
      value != oldDelegate.value ||
      color != oldDelegate.color ||
      track != oldDelegate.track;
}
