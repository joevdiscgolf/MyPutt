import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class CustomFadeShimmer extends StatelessWidget {
  const CustomFadeShimmer({
    Key? key,
    required this.height,
    required this.width,
    this.radius = 4,
  }) : super(key: key);

  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return FadeShimmer(
      height: height,
      width: width,
      radius: radius,
      millisecondsDelay: 0,
      highlightColor: MyPuttColors.gray[50]!,
      baseColor: MyPuttColors.gray[100]!,
    );
  }
}
