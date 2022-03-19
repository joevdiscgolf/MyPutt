import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FadeShimmer(
              height: 22,
              width: 64,
              radius: 16,
              millisecondsDelay: 0,
              highlightColor: MyPuttColors.gray[100],
              baseColor: MyPuttColors.gray[50],
            ),
            const SizedBox(height: 8),
            FadeShimmer(
              height: 36,
              width: 108,
              radius: 16,
              millisecondsDelay: 0,
              highlightColor: MyPuttColors.gray[100],
              baseColor: MyPuttColors.gray[50],
            ),
            const SizedBox(height: 16),
            FadeShimmer(
              height: 164,
              width: double.infinity,
              radius: 16,
              millisecondsDelay: 300,
              highlightColor: MyPuttColors.gray[100],
              baseColor: MyPuttColors.gray[50],
            ),
            const SizedBox(height: 16),
            FadeShimmer(
              height: 300,
              width: double.infinity,
              radius: 16,
              millisecondsDelay: 900,
              highlightColor: MyPuttColors.gray[100],
              baseColor: MyPuttColors.gray[50],
            ),
          ],
        ),
      ),
    );
  }
}
