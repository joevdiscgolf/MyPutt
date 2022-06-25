import 'package:flutter/material.dart';

import '../../../models/data/challenges/putting_challenge.dart';

class ChallengeCategoryTab extends StatelessWidget {
  const ChallengeCategoryTab(
      {Key? key,
      required this.challenges,
      required this.label,
      required this.icon,
      required this.showCounter})
      : super(key: key);

  final String label;
  final Icon icon;
  final List<PuttingChallenge> challenges;
  final bool showCounter;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
        child: Tab(
            icon: icon,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label),
              ],
            )),
      ),
      Positioned(
          top: 5,
          right: 0,
          child: Visibility(
              visible: challenges.isNotEmpty && showCounter,
              child: Container(
                width: 15,
                height: 15,
                child: Center(
                  child: Text(challenges.length.toString(),
                      style: const TextStyle(color: Colors.black)),
                ),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
              )))
    ]);
  }
}
