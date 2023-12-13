import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  const DashedLine({
    Key? key,
    required this.color,
    this.height = 300,
    this.width = 300,
    this.strokeWidth = 2,
    this.dashLength = 4,
    this.dashSpacing = 6,
    this.axis = Axis.horizontal,
  }) : super(key: key);

  final Color color;
  final double height;
  final double width;
  final double strokeWidth;
  final double dashLength;
  final double dashSpacing;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CustomPaint(
        painter: DashedLinePainter(
          color: color,
          strokeWidth: strokeWidth,
          dashLength: dashLength,
          dashSpacing: dashSpacing,
          axis: axis,
        ),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  DashedLinePainter({
    required this.color,
    this.strokeWidth = 2,
    this.dashLength = 4,
    this.dashSpacing = 6,
    this.axis = Axis.horizontal,
  });

  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashSpacing;
  final Axis axis;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    switch (axis) {
      case Axis.horizontal:
        _drawHorizontalLine(canvas, paint, size);
        break;
      case Axis.vertical:
        _drawVerticalLine(canvas, paint, size);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _drawHorizontalLine(Canvas canvas, Paint paint, Size size) {
    double startX = 0;
    double y = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, y), Offset(startX + dashLength, y), paint);
      startX += (dashLength + dashSpacing);
    }
  }

  void _drawVerticalLine(Canvas canvas, Paint paint, Size size) {
    double startY = 0;
    double x = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset(x, startY), Offset(x, startY + dashLength), paint);
      startY += (dashLength + dashSpacing);
    }
  }
}
