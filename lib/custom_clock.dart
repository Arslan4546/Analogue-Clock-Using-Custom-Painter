import 'dart:math';
import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  final DateTime currentTime;
  final bool isDarkMode;

  ClockPainter({required this.currentTime, required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width, size.height) / 2;
    final center = Offset(size.width / 2, size.height / 2);

    // Theme-based colors
    final Color borderColor = isDarkMode ? Colors.white70 : Colors.black;
    final Color tickColor = isDarkMode ? Colors.white : Colors.black;
    final Color secondHandColor = isDarkMode ? Colors.redAccent : Colors.red;
    final Color centerDotColor = isDarkMode ? Colors.white : Colors.black;

    // Paint for Clock Border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    // Paint for Center Dot
    final centerPaint = Paint()
      ..color = centerDotColor
      ..style = PaintingStyle.fill;

    // Draw Clock Border
    canvas.drawCircle(center, radius, borderPaint);

    // Draw Center Dot
    canvas.drawCircle(center, 5, centerPaint);

    // Draw Hour and Minute Ticks
    _drawTicks(canvas, size, center, tickColor);

    // Draw Hour, Minute, and Second Hands
    _drawNeedles(canvas, size, center, secondHandColor);
  }

  void _drawTicks(Canvas canvas, Size size, Offset center, Color tickColor) {
    final radius = min(size.width, size.height) / 2;
    const angle = 2 * pi / 60;

    final hoursTickPaint = Paint()
      ..color = tickColor
      ..strokeWidth = 5.0;

    final minutesTickPaint = Paint()
      ..color = tickColor.withOpacity(0.6)
      ..strokeWidth = 3.0;

    canvas.save();
    canvas.translate(center.dx, center.dy);

    for (var i = 1; i <= 60; i++) {
      bool isHourTick = i % 5 == 0;
      canvas.drawLine(
        Offset(0, -radius),
        Offset(0, -radius + (isHourTick ? 15 : 10)),
        isHourTick ? hoursTickPaint : minutesTickPaint,
      );
      canvas.rotate(angle);
    }

    canvas.restore();
  }

  void _drawNeedles(
      Canvas canvas, Size size, Offset center, Color secondHandColor) {
    final radius = min(size.width, size.height) / 2;

    final hourPaint = Paint()
      ..color = isDarkMode ? Colors.white70 : Colors.black
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final minutePaint = Paint()
      ..color = isDarkMode ? Colors.white70 : Colors.black
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final secondPaint = Paint()
      ..color = secondHandColor
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Calculate angles for each hand
    final hourAngle = (2 * pi / 12) * (currentTime.hour % 12) +
        (2 * pi / 12 / 60) * currentTime.minute;
    final minuteAngle = (2 * pi / 60) * currentTime.minute +
        (2 * pi / 60 / 60) * currentTime.second;
    final secondAngle = (2 * pi / 60) * currentTime.second;

    // Draw hour, minute, and second hands
    _drawNeedle(canvas, center, radius * 0.5, hourAngle, hourPaint);
    _drawNeedle(canvas, center, radius * 0.6, minuteAngle, minutePaint);
    _drawNeedle(canvas, center, radius * 0.8, secondAngle, secondPaint);
  }

  void _drawNeedle(
      Canvas canvas, Offset center, double length, double angle, Paint paint) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle - pi / 2); // Rotate with adjustment for 0 position
    canvas.drawLine(Offset(0, 0), Offset(0, -length), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
