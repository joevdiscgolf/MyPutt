import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/models/data/conditions/condition_enums.dart';
import 'package:myputt/utils/constants/record_constants.dart';

class WindDirectionIcon extends StatelessWidget {
  const WindDirectionIcon({Key? key, required this.windDirection})
      : super(key: key);

  final WindDirection windDirection;

  @override
  Widget build(BuildContext context) {
    final double angle = windDirectionToAngleMap[windDirection] ?? 0;

    return Transform.rotate(
      angle: angle,
      child: const Icon(FlutterRemix.arrow_up_line),
    );
  }
}
