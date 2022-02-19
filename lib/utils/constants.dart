import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

class ChallengeStatus {
  static String pending = 'pending';
  static String active = 'active';
  static String complete = 'complete';
}

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

enum ChallengeCategory { pending, active, complete, none }

enum LoginState { loggedIn, setup, none }

const blueFrisbeeIcon = AssetImage('assets/frisbeeEmojiCutout.png');
const redFrisbeeIcon = AssetImage('assets/frisbeeEmojiCutoutRed.png');
