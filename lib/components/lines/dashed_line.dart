import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  const DashedLine({
    Key? key,
    this.height = 300,
    this.width = 300,
    required this.color,
  }) : super(key: key);

  final double height;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CustomPaint(painter: DashedLinePainter(color: color)),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  DashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 2;

    _drawDashedLine(canvas, paint, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Size size) {
    const int dashWidth = 4;
    const int dashSpace = 6;

    double startX = 0;
    double y = 10;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y), paint);
      startX += dashWidth + dashSpace;
    }
  }
}
