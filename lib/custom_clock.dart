import 'dart:math';
import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  final DateTime currentTime;

  ClockPainter({required this.currentTime});

  @override
  void paint(Canvas canvas, Size size) {
    final Size(:height, :width) = size;
    final radius = min(width, height) / 2;
    final hoursTickLength = radius * 0.15;
    final hoursTickWidth = radius * 0.05;
    final minutesTickLength = radius * 0.1;
    final minutesTickWidth = radius * 0.025;
    const angle = 2 * pi / 60;

    final center = Offset(width / 2, height / 2);

    // Paint for Clock Border
    final paint = Paint()
      ..color = Colors.black // Black color for the border
      ..style = PaintingStyle.stroke // Border only
      ..strokeWidth = 5.0; // Thickness of the border

    // Paint for Center Dot
    final centerPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Paint for Hour Ticks
    final hoursTickPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = hoursTickWidth;

    // Paint for Minute Ticks
    final minutesTickPaint = Paint()
      ..color = Colors.black26
      ..strokeWidth = minutesTickWidth;

    // Draw Dial Face
    canvas.drawCircle(center, radius, paint);

    // Draw Center Point
    canvas.drawCircle(center, 10, centerPaint);

    // Draw Hour and Minute Ticks
    canvas.save();
    canvas.translate(center.dx, center.dy);
    for (var i = 1; i <= 60; i++) {
      var isHours = i % 5 == 0;

      // Draw Hours Tick / Or Minute Tick
      canvas.drawLine(
          Offset(0, -radius),
          Offset(0, -radius + (isHours ? hoursTickLength : minutesTickLength)),
          isHours ? hoursTickPaint : minutesTickPaint);
      canvas.rotate(angle);
    }
    canvas.restore();

    // Hour, Minute, and Second Needles
    _drawNeedles(canvas, size, center);
  }

  void _drawNeedles(Canvas canvas, Size size, Offset center) {
    final radius = min(size.width, size.height) / 2;

    // Paint for Hour and Minute Needles
    final needlePaint = Paint()
      ..color = Colors.black // Same color for hour and minute needles
      ..style = PaintingStyle.fill;

    // Paint for Second Needle
    final secondNeedlePaint = Paint()
      ..color = Colors.red // Different color for second needle
      ..style = PaintingStyle.fill;

    // Calculate angles based on the current time
    final hourAngle = (2 * pi / 12) * (currentTime.hour % 12) +
        (2 * pi / 12 / 60) * currentTime.minute;
    final minuteAngle = (2 * pi / 60) * currentTime.minute +
        (2 * pi / 60 / 60) * currentTime.second;
    final secondAngle = (2 * pi / 60) * currentTime.second;

    // Hour Needle (shorter)
    _drawNeedle(canvas, center, radius * 0.5, hourAngle, 6, needlePaint);

    // Minute Needle (longer than hour needle)
    _drawNeedle(canvas, center, radius * 0.7, minuteAngle, 4, needlePaint);

    // Second Needle (longest and red)
    _drawNeedle(
        canvas, center, radius * 0.8, secondAngle, 2, secondNeedlePaint);
  }

  void _drawNeedle(Canvas canvas, Offset center, double length, double angle,
      double baseWidth, Paint paint) {
    final Path needlePath = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(center.dx - baseWidth / 2 * cos(angle + pi / 2),
          center.dy - baseWidth / 2 * sin(angle + pi / 2)) // Left edge
      ..lineTo(center.dx + length * cos(angle),
          center.dy + length * sin(angle)) // Tip of the needle
      ..lineTo(center.dx + baseWidth / 2 * cos(angle + pi / 2),
          center.dy + baseWidth / 2 * sin(angle + pi / 2)) // Right edge
      ..close();

    canvas.drawPath(needlePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
