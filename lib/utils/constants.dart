import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

class ChallengeStatus {
  static String pending = 'pending';
  static String active = 'active';
  static String complete = 'complete';
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
