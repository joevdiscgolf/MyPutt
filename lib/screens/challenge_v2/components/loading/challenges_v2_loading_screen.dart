import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class ChallengesV2LoadingScreen extends StatelessWidget {
  const ChallengesV2LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      for (int i = 0; i < 4; i++) ...[
        if (i != 0) const SizedBox(height: 16),
        FadeShimmer(
          height: 148,
          width: double.infinity,
          radius: 8,
          millisecondsDelay: 300,
          highlightColor: MyPuttColors.gray[100],
          baseColor: MyPuttColors.gray[50],
        ),
      ]
    ];
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      physics: const AlwaysScrollableScrollPhysics(),
      children: children,
    );
  }
}
