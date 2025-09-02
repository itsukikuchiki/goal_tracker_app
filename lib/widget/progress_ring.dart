import 'package:flutter/material.dart';
import 'dart:math';

class ProgressRing extends StatelessWidget {
  final double percentage; // 0.0 ~ 1.0

  const ProgressRing({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    final percent = (percentage.clamp(0.0, 1.0) * 100).round();

    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(40, 40),
            painter: _RingPainter(percentage),
          ),
          Text(
            '$percent%',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;

  _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 4.0;
    final center = size.center(Offset.zero);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final foregroundPaint = Paint()
      ..color = Colors.greenAccent.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // 背景环
    canvas.drawCircle(center, radius, backgroundPaint);

    // 进度弧线
    final angle = 2 * pi * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      angle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

