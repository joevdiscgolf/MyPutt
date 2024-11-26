import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/enums.dart';

class CircleRadialDiagram extends StatelessWidget {
  const CircleRadialDiagram({super.key, required this.selectedCircle});

  final PuttingCircle selectedCircle;

  static const Map<PuttingCircle, double> _circleToSize = {
    PuttingCircle.c1: 30,
    PuttingCircle.c2: 60,
    PuttingCircle.c3: 90
  };

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [PuttingCircle.c3, PuttingCircle.c2, PuttingCircle.c1]
          .map((circle) => _circle(circle))
          .toList(),
    );
  }

  Widget _circle(PuttingCircle circle) {
    final double size = _circleToSize[circle] ?? 0;

    final bool isSelected = circle == selectedCircle;
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: MyPuttColors.gray[200]!),
        shape: BoxShape.circle,
        color: isSelected ? null : MyPuttColors.white,
        gradient: isSelected
            ? const LinearGradient(
                colors: [MyPuttColors.blue, MyPuttColors.purple])
            : null,
      ),
    );
  }
}
