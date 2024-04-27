import 'dart:math';

import 'package:flutter/material.dart';


class UShapedContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const UShapedContainer({super.key,
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: UShapePainter(color),
    );
  }
}

class UShapePainter extends CustomPainter {
  final Color color;

  UShapePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;

    final double arcHeight = size.height / 2;

    final Rect arcRect = Rect.fromLTWH(0, 0, size.width, arcHeight);
    final Rect bodyRect =
    Rect.fromLTWH(0, arcHeight / 2, size.width, size.height - arcHeight / 2);

    canvas.drawArc(arcRect, pi, pi, true, paint);
    canvas.drawRect(bodyRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}