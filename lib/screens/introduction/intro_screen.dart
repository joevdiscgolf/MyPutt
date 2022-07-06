import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/screens/auth/login_screen.dart';
import 'package:myputt/screens/introduction/constants.dart';
import 'package:myputt/utils/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'components/carousel_hero.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < 4) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MyPuttColors.faintBlue,
              MyPuttColors.white,
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _carouselBody(context),
        ),
      ),
    );
  }

  Widget _carouselBody(BuildContext context) {
    final bool addBottomPadding = MediaQuery.of(context).viewPadding.bottom > 0;
    List<Widget> carouselChildren = [
      const CarouselHero(
        assetPath: kHomeScreenScreenshotSrc,
      ),
    ];
    carouselChildren.addAll(kCarouselItems);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const ClampingScrollPhysics(),
            children: carouselChildren,
          ),
        ),
        SmoothPageIndicator(
          controller: _pageController,
          count: 5,
          effect: ExpandingDotsEffect(
            activeDotColor: MyPuttColors.darkGray,
            dotColor: MyPuttColors.gray[200]!,
            dotHeight: 6,
            dotWidth: 6,
            spacing: 4,
          ),
        ),
        const SizedBox(height: 48),
        MyPuttButton(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          title: 'Continue to app',
          textColor: MyPuttColors.white,
          iconColor: MyPuttColors.white,
          backgroundColor: MyPuttColors.darkGray,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const LoginScreen()));
          },
        ),
        SizedBox(height: addBottomPadding ? 64 : 24),
      ],
    );
  }
}
