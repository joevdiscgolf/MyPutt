import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class EventStandingsLoadingScreen extends StatelessWidget {
  const EventStandingsLoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [for (int i = 0; i < 5; i++) _fadeShimmerRow(context)],
    );
  }

  Widget _fadeShimmerRow(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 16),
          FadeShimmer(
            width: 32,
            radius: 4,
            millisecondsDelay: 300,
            highlightColor: MyPuttColors.gray[100],
            baseColor: MyPuttColors.gray[50],
            height: 32,
          ),
          const SizedBox(width: 16),
          FadeShimmer(
            width: 32,
            radius: 16,
            millisecondsDelay: 300,
            highlightColor: MyPuttColors.gray[100],
            baseColor: MyPuttColors.gray[50],
            height: 32,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeShimmer(
                height: 10,
                width: 48,
                radius: 2,
                millisecondsDelay: 300,
                highlightColor: MyPuttColors.gray[100],
                baseColor: MyPuttColors.gray[50],
              ),
              const SizedBox(height: 4),
              FadeShimmer(
                height: 10,
                width: 32,
                radius: 2,
                millisecondsDelay: 300,
                highlightColor: MyPuttColors.gray[100],
                baseColor: MyPuttColors.gray[50],
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: FadeShimmer(
              height: 32,
              width: 100,
              radius: 8,
              millisecondsDelay: 300,
              highlightColor: MyPuttColors.gray[100],
              baseColor: MyPuttColors.gray[50],
            ),
          ),
          const SizedBox(width: 16)
        ],
      ),
    );
  }
}
