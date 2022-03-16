import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/misc/frisbee_circle_icon.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/string_helpers.dart';

class ChallengeResultDialog extends StatelessWidget {
  const ChallengeResultDialog(
      {Key? key, required this.difference, this.challenge})
      : super(key: key);

  final PuttingChallenge? challenge;
  final int difference;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            child: _mainBody(context)));
  }

  Widget _mainBody(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${getMessageFromDifference(difference)}!',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontSize: 40, color: getColorFromDifference(difference)),
              ),
              const SizedBox(
                height: 12,
              ),
              AutoSizeText(
                getSubtitleFromDifference(difference),
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 20, color: MyPuttColors.gray[300]),
                maxLines: 1,
              ),
              const AnimatedMedal(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _profileColumn(
                    context,
                    challenge?.currentUser.displayName ?? 'You',
                    MyPuttColors.gray[100]!),
                _centerColumn(context),
                _profileColumn(
                    context,
                    challenge?.currentUser.displayName ?? 'Opponent',
                    MyPuttColors.gray[100]!)
              ]),
            ]));
  }

  Widget _profileColumn(
    BuildContext context,
    String displayName,
    Color backgroundColor,
  ) {
    return Column(
      children: [
        Text(
          displayName,
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontSize: 16, color: MyPuttColors.gray[500]),
        ),
        const SizedBox(
          height: 8,
        ),
        FrisbeeCircleIcon(
          size: 72,
          backGroundColor: backgroundColor,
          redIcon: backgroundColor == MyPuttColors.blue,
        ),
      ],
    );
  }

  Widget _centerColumn(BuildContext context) {
    const int currentUserPuttsMade = 10;
    const int opponentPuttsMade = 10;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(currentUserPuttsMade.toString(),
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 20, color: MyPuttColors.blue)),
            Text(' : ',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 20, color: MyPuttColors.gray[400])),
            Text(opponentPuttsMade.toString(),
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 20, color: MyPuttColors.red))
          ],
        ),
      ],
    );
  }

  String getSubtitleFromDifference(int difference) {
    if (difference > 0) {
      final _random = Random();
      return victorySubtitles[_random.nextInt(victorySubtitles.length)];
    } else if (difference < 0) {
      final _random = Random();
      return defeatSubtitles[_random.nextInt(defeatSubtitles.length)];
    } else {
      return 'This calls for a rematch';
    }
  }
}

class AnimatedMedal extends StatefulWidget {
  const AnimatedMedal({Key? key}) : super(key: key);

  @override
  _AnimatedMedalState createState() => _AnimatedMedalState();
}

class _AnimatedMedalState extends State<AnimatedMedal>
    with TickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;
  late final AnimationController _rotateController;
  late final Animation<double> _rotateAnimation;
  late final Animation<double> _opacityAnimation;
  int rotateCycles = 0;

  @override
  void initState() {
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 600),
    );
    _rotateController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    final CurvedAnimation scaleCurve = CurvedAnimation(
        parent: _scaleController,
        curve: Curves.decelerate,
        reverseCurve: const SpringCurve());

    final CurvedAnimation rotateCurve =
        CurvedAnimation(parent: _rotateController, curve: const SineCurve());

    _scaleAnimation = Tween<double>(begin: 140, end: 200).animate(scaleCurve)
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _scaleController.reverse();
        }
      });
    _rotateAnimation = Tween<double>(begin: 1, end: 0).animate(rotateCurve)
      ..addListener(() => setState(() {}));
    // ..addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     _rotateController.reverse();
    //     rotateCycles += 1;
    //   }
    //   if (status == AnimationStatus.dismissed && rotateCycles < 3) {
    //     _rotateController.forward();
    //   }
    // })
    //
    _opacityAnimation = Tween<double>(begin: 1, end: 0.5).animate(scaleCurve)
      ..addListener(() => setState(() {}));
    _scaleController.forward();
    _rotateController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      width: 240,
      child: Center(
        child: Transform.rotate(
          angle: 0,
          // angle: _rotateAnimation.value,
          child: Icon(
            FlutterRemix.medal_line,
            size: _scaleAnimation.value,
            color: MyPuttColors.gray.withOpacity(_opacityAnimation.value),
          ),
        ),
      ),
    );
  }
}

class SineCurve extends Curve {
  final double count;

  const SineCurve({this.count = 3});

  @override
  double transformInternal(double t) {
    var val = sin(count * 2 * pi * t) * 0.5 + 0.5;
    return val;
  }
}

class SpringCurve extends Curve {
  const SpringCurve({this.a = 0.1, this.w = 30});
  final double a;
  final double w;
  @override
  double transformInternal(double t) {
    var val = -(pow(e, -t / a) * cos(t * w)) + 1;
    return val;
  }
}
