import 'dart:math';

import 'package:flutter/material.dart';

class CircleNotch extends CustomPainter {
  const CircleNotch({
    required this.bgColor,
    required this.circleColor,
    required this.circleRadius,
    required this.position,
    this.topRadius = 20,
    this.margin = 5,
  });

  final Color bgColor;
  final Color circleColor;
  final double position;
  final double circleRadius;
  final double topRadius;
  final double margin;

  @override
  void paint(Canvas canvas, Size size) {
    final shapeBounds = Rect.fromLTRB(0, 0, size.width, size.height);
    final circleBounds = Rect.fromCircle(
            center: Offset(position, circleRadius), radius: circleRadius)
        .inflate(margin);

    _drawBackground(canvas, shapeBounds, circleBounds);
    _drawCircle(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _drawBackground(Canvas canvas, Rect shapeBounds, Rect circleBounds) {
    final paint = Paint()..color = bgColor;
    const deg = pi / 3;

    final path = Path()
      ..moveTo(shapeBounds.bottomLeft.dx, shapeBounds.bottomLeft.dy)
      ..lineTo(shapeBounds.topLeft.dx, shapeBounds.topLeft.dy + topRadius)
      ..relativeArcToPoint(
        Offset(topRadius, -topRadius),
        radius: Radius.circular(topRadius),
      )
      ..lineTo(shapeBounds.topLeft.dx + topRadius, shapeBounds.topLeft.dy)
      ..arcTo(circleBounds, -2 * deg, -5 * deg, false)
      ..lineTo(shapeBounds.topRight.dx - topRadius, shapeBounds.topRight.dy)
      ..relativeArcToPoint(
        Offset(topRadius, topRadius),
        radius: Radius.circular(topRadius),
      )
      ..lineTo(shapeBounds.bottomRight.dx, shapeBounds.bottomRight.dy)
      ..close();

    canvas.drawShadow(path.shift(const Offset(0, -5)), Colors.black, 10, true);
    canvas.drawPath(path, paint);
  }

  void _drawCircle(Canvas canvas) {
    final paint = Paint()..color = circleColor;
    final circlePosition = Offset(position, circleRadius);

    canvas.drawCircle(circlePosition, circleRadius, paint);
  }
}
