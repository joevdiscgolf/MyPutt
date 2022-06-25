import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class EventSearchLoadingScreen extends StatelessWidget {
  const EventSearchLoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      for (int i = 0; i < 3; i++) ...[
        if (i != 0) const SizedBox(height: 8),
        FadeShimmer(
          height: 180,
          width: double.infinity,
          radius: 8,
          millisecondsDelay: 300,
          highlightColor: MyPuttColors.gray[100],
          baseColor: MyPuttColors.gray[50],
        ),
      ]
    ];
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
