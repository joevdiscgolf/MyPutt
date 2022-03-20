import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/auth/landing_screen.dart';
import 'package:myputt/screens/introduction/constants.dart';
import 'package:myputt/services/shared_preferences_service.dart';
import 'package:myputt/utils/colors.dart';

class MyPuttIntroductionScreen extends StatelessWidget {
  MyPuttIntroductionScreen({Key? key}) : super(key: key);

  final SharedPreferencesService _sharedPreferencesService =
      locator.get<SharedPreferencesService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 120),
        child: SizedBox(
          child: IntroductionScreen(
            pages: kIntroPages,
            onDone: () {
              _sharedPreferencesService.setBooleanValue('isFirstRun', false);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const LandingScreen()));
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
