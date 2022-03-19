import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:myputt/screens/introduction/constants.dart';
import 'package:myputt/utils/colors.dart';

class MyPuttIntroductionScreen extends StatelessWidget {
  const MyPuttIntroductionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 120),
        child: Align(
          alignment: Alignment.center,
          child: IntroductionScreen(
            pages: kIntroPages,
            onDone: () {
              // When done button is press
            },
            onSkip: () {
              // You can also override onSkip callback
            },
            showBackButton: false,
            showSkipButton: false,
            skip: const Icon(Icons.skip_next),
            next: const Icon(
              FlutterRemix.arrow_right_line,
              color: MyPuttColors.gray,
            ),
            done: AutoSizeText(
              "Continue to app",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontSize: 16, color: MyPuttColors.blue),
              maxLines: 1,
            ),
            dotsDecorator: DotsDecorator(
                size: const Size.square(10.0),
                activeSize: const Size(20.0, 10.0),
                activeColor: MyPuttColors.lightBlue,
                color: Colors.black26,
                spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0))),
          ),
        ),
      ),
    );
  }
}
