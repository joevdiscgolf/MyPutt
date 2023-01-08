import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

class ChallengesIcon extends StatelessWidget {
  const ChallengesIcon({Key? key, required this.numPendingChallenges})
      : super(key: key);

  final int numPendingChallenges;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Center(child: Icon(FlutterRemix.sword_fill)),
        if (numPendingChallenges > 0)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  numPendingChallenges.toString(),
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          )
      ],
    );
  }
}
