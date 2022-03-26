import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      const SizedBox(
        height: 16,
      ),
      FadeShimmer(
        height: 300,
        width: double.infinity,
        radius: 16,
        millisecondsDelay: 300,
        highlightColor: MyPuttColors.gray[100],
        baseColor: MyPuttColors.gray[50],
      ),
    ];
    children.addAll([
      for (int i = 0; i < 2; i++) ...[
        const SizedBox(
          height: 16,
        ),
        FadeShimmer(
          height: 100,
          width: double.infinity,
          radius: 16,
          millisecondsDelay: 300,
          highlightColor: MyPuttColors.gray[100],
          baseColor: MyPuttColors.gray[50],
        ),
      ]
    ]);
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: ListView(
          children: children,
        ),
      ),
    );
  }
}
