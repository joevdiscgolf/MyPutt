import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

class ChallengeStatus {
  static String pending = 'pending';
  static String active = 'active';
  static String complete = 'complete';
}

enum ChallengeCategory { pending, active, complete, none }

enum LoginState { loggedIn, setup, none }

class DefaultProfileCircle extends StatelessWidget {
  const DefaultProfileCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration:
          BoxDecoration(color: Colors.grey[300]!, shape: BoxShape.circle),
      child:
          Center(child: Icon(FlutterRemix.user_fill, color: Colors.grey[600]!)),
    );
  }
}

const blueFrisbeeIcon = AssetImage('assets/frisbeeEmojiCutout.png');
const redFrisbeeIcon = AssetImage('assets/frisbeeEmojiCutoutRed.png');

class Cutoffs {
  static const int c1x = 11;
  static const int c2 = 33;
  static const int none = 0;
}

const blueFrisbeeImageIcon = SizedBox(
  height: 20,
  width: 20,
  child: Image(
    image: AssetImage('assets/frisbeeEmojiCutout.png'),
  ),
);
const redFrisbeeImageIcon = SizedBox(
  height: 20,
  width: 20,
  child: Image(
    image: AssetImage('assets/frisbeeEmojiCutoutRed.png'),
  ),
);
