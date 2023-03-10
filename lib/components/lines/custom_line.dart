import 'package:flutter/material.dart';

class CustomLine extends StatelessWidget {
  const CustomLine({
    Key? key,
    this.height = 300,
    this.width = 300,
    required this.color,
    this.isDashed = false,
  }) : super(key: key);

  final double height;
  final double width;

  final Color color;
  final bool isDashed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CustomPaint(
        painter: isDashed
            ? DashedLinePainter(color: color)
            : SolidLinePainter(color: color, height: height),
      ),
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

class SolidLinePainter extends CustomPainter {
  SolidLinePainter({required this.color, required this.height});

  final Color color;
  final double height;

  @override
  void paint(Canvas canvas, Size size) {
    const p1 = Offset(0, 0);
    final p2 = Offset(0, height);
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
