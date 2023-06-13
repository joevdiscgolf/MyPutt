import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/misc/frisbee_circle_icon.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/models/data/users/frisbee_avatar.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/string_helpers.dart';
import 'package:myputt/components/misc/fade_in_widget.dart';

class ChallengeResultScreen extends StatefulWidget {
  const ChallengeResultScreen({
    Key? key,
    required this.challenge,
  }) : super(key: key);

  final PuttingChallenge challenge;

  @override
  State<ChallengeResultScreen> createState() => _ChallengeResultScreenState();
}

class _ChallengeResultScreenState extends State<ChallengeResultScreen> {
  final UserRepository _userRepository = locator.get<UserRepository>();

  bool _showButton = false;
  late final IconData _iconData;
  late final String _subtitle;
  late final int _difference;

  @override
  void initState() {
    _difference = getDifferenceFromChallenge(widget.challenge);
    if (_difference >= 0) {
      _iconData = FlutterRemix.medal_2_fill;
    } else {
      _iconData = FlutterRemix.emotion_sad_fill;
    }
    _subtitle = getSubtitleFromDifference(_difference);
    _showDelayedButton();
    super.initState();
  }

  Future<void> _showDelayedButton() async {
    await Future.delayed(const Duration(milliseconds: 3000),
        () => setState(() => _showButton = true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _mainBody(context));
  }

  Widget _mainBody(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 64, left: 32, right: 32),
        width: double.infinity,
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${getMessageFromDifference(_difference)}!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 40,
                            color: getColorFromDifference(_difference)),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      AutoSizeText(
                        _subtitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 20, color: MyPuttColors.gray[300]),
                        maxLines: 1,
                      ),
                      AnimatedIcon(iconData: _iconData),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _profileColumn(
                                context,
                                widget.challenge.currentUser.displayName,
                                _userRepository.currentUser?.frisbeeAvatar),
                            _centerColumn(context),
                            _profileColumn(
                              context,
                              widget.challenge.opponentUser?.displayName ??
                                  'Opponent',
                              widget.challenge.opponentUser?.frisbeeAvatar,
                            )
                          ]),
                    ],
                  ),
                ),
                _showButton
                    ? FadeInWidget(
                        duration: const Duration(milliseconds: 1000),
                        child: MyPuttButton(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            height: 50,
                            title: 'Continue',
                            iconData: FlutterRemix.check_line,
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      )
                    : const SizedBox(height: 50),
                const SizedBox(height: 32)
              ]),
        ));
  }

  Widget _profileColumn(
    BuildContext context,
    String displayName,
    FrisbeeAvatar? frisbeeAvatar,
  ) {
    return Column(
      children: [
        Text(
          displayName,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: 16, color: MyPuttColors.gray[500]),
        ),
        const SizedBox(
          height: 8,
        ),
        FrisbeeCircleIcon(
          size: 72,
          frisbeeAvatar: frisbeeAvatar,
        ),
      ],
    );
  }

  Widget _centerColumn(BuildContext context) {
    final int currentUserPuttsMade = getPuttsMadeFromChallenge(
        widget.challenge.currentUser.uid, widget.challenge);
    final int opponentPuttsMade = widget.challenge.opponentUser != null
        ? getPuttsMadeFromChallenge(
            widget.challenge.opponentUser!.uid, widget.challenge)
        : 0;
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
                    .titleLarge
                    ?.copyWith(fontSize: 20, color: MyPuttColors.blue)),
            Text(' : ',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 20, color: MyPuttColors.gray[400])),
            Text(opponentPuttsMade.toString(),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 20, color: MyPuttColors.red))
          ],
        ),
      ],
    );
  }

  String getSubtitleFromDifference(int difference) {
    final Random random = Random();
    if (difference > 0) {
      return victorySubtitles[random.nextInt(victorySubtitles.length)];
    } else if (difference < 0) {
      return defeatSubtitles[random.nextInt(defeatSubtitles.length)];
    } else {
      return 'This calls for a rematch';
    }
  }
}

class AnimatedIcon extends StatefulWidget {
  const AnimatedIcon({Key? key, required this.iconData}) : super(key: key);

  final IconData iconData;

  @override
  _AnimatedIconState createState() => _AnimatedIconState();
}

class _AnimatedIconState extends State<AnimatedIcon>
    with TickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;
  late final AnimationController _rotateController;
  late final Animation<double> _opacityAnimation;
  int rotateCycles = 0;

  @override
  void initState() {
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 800),
    );
    _rotateController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    final CurvedAnimation scaleCurve = CurvedAnimation(
        parent: _scaleController,
        curve: Curves.decelerate,
        reverseCurve: const SpringCurve());

    _scaleAnimation = Tween<double>(begin: 140, end: 200).animate(scaleCurve)
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _scaleController.reverse();
        }
      });
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
          child: Icon(
            widget.iconData,
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
