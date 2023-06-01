import 'dart:math';

import 'package:flutter/material.dart';

class CircleNotch extends CustomPainter {
  const CircleNotch({
    required this.bgColor,
    required this.circleColor,
    required this.radius,
    required this.position,
    this.margin = 5,
  });

  final Color bgColor;
  final Color circleColor;
  final Offset position;
  final double radius;
  final double margin;

  @override
  void paint(Canvas canvas, Size size) {
    final shapeBounds = Rect.fromLTRB(0, 0, size.width, size.height);
    final circleBounds =
        Rect.fromCircle(center: position, radius: radius).inflate(margin);

    _drawBackground(canvas, shapeBounds, circleBounds);
    _drawCircle(canvas, position);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _drawBackground(Canvas canvas, Rect shapeBounds, Rect circleBounds) {
    final paint = Paint()..color = bgColor;

    final path = Path()
      ..moveTo(shapeBounds.bottomLeft.dx, shapeBounds.bottomLeft.dy)
      ..lineTo(shapeBounds.topLeft.dx, shapeBounds.topLeft.dy)
      ..arcTo(circleBounds, pi, -pi, false)
      ..lineTo(shapeBounds.topRight.dx, shapeBounds.topRight.dy)
      ..lineTo(shapeBounds.bottomRight.dx, shapeBounds.bottomRight.dy)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawShadow(path, Colors.grey.withAlpha(50), 1.5, false);
  }

  void _drawCircle(Canvas canvas, Offset position) {
    final paint = Paint()..color = circleColor;
    canvas.drawCircle(position, radius, paint);
  }
}
