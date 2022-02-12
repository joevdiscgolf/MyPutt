import 'package:flutter/material.dart';

import '../../../data/types/putting_challenge.dart';
import 'package:flutter_remix/flutter_remix.dart';

class ChallengeCategoryTab extends StatelessWidget {
  const ChallengeCategoryTab(
      {Key? key,
      required this.challenges,
      required this.label,
      required this.icon})
      : super(key: key);

  final String label;
  final Icon icon;
  final List<PuttingChallenge> challenges;

  @override
  Widget build(BuildContext context) {
    return Tab(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label),
        icon,
        Visibility(
            visible: challenges.isNotEmpty,
            child: Container(
              width: 15,
              height: 15,
              child: Center(
                child: Text(challenges.length.toString(),
                    style: const TextStyle(color: Colors.black)),
              ),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
            ))
      ],
    ));
  }
}
