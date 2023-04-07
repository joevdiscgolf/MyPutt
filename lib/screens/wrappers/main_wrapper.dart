import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/challenge_v2/challenges_screen_v2.dart';
import 'package:myputt/screens/events/events_screen.dart';
import 'package:myputt/screens/home/home_screen.dart';
import 'package:myputt/screens/home_v2/home_screen_v2.dart';
import 'package:myputt/screens/my_profile/my_profile_screen.dart';
import 'package:myputt/screens/sessions/sessions_screen.dart';
import 'package:myputt/screens/challenge/challenges_screen.dart';
import 'package:myputt/screens/wrappers/components/myputt_bottom_nav_item.dart';
import 'package:myputt/services/beta_access_service.dart';
import 'package:myputt/services/navigation_service.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants/beta_access_constants.dart';
import 'package:myputt/utils/layout_helpers.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({Key? key}) : super(key: key);

  static String routeName = '/';

  @override
  _MainWrapperState createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final NavigationService _navigationService = locator.get<NavigationService>();
  int _currentIndex = 0;

  late final List<Widget> _screens;
  late final bool _eventsV1Beta;
  late final bool _homeScreenV2;
  late final bool _challengesV2Screen;

  late final StreamSubscription<int> _tabStreamSubscription;

  @override
  void dispose() {
    _tabStreamSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _tabStreamSubscription =
        _navigationService.mainWrapperTabStream.listen((int newIndex) {
      setState(() {
        _currentIndex = newIndex;
      });
    });
    _eventsV1Beta = locator
        .get<BetaAccessService>()
        .hasFeatureAccess(featureName: kEventsV1Beta);
    _homeScreenV2 = locator
        .get<BetaAccessService>()
        .hasFeatureAccess(featureName: kHomeScreenV2Beta);
    _challengesV2Screen = locator
        .get<BetaAccessService>()
        .hasFeatureAccess(featureName: kChallengesScreenV2Beta);

    _screens = <Widget>[
      _homeScreenV2 ? const HomeScreenV2() : const HomeScreen(),
      const SessionsScreen(),
      _challengesV2Screen
          ? const ChallengesScreenV2()
          : const ChallengesScreen(),
      if (_eventsV1Beta) const EventsScreen(),
      const MyProfileScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _screens[_currentIndex]),
          _bottomNavigationBar(),
        ],
      ),
    );
  }

  Widget _bottomNavigationBar() {
    final double bottomPadding = bottomNavBarPadding(context);
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: MyPuttColors.white,
              border: Border(
                top: BorderSide(
                  color: MyPuttColors.gray[200]!,
                  width: 2,
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: MyPuttBottomNavItem(
                      iconData: FlutterRemix.home_2_fill,
                      isSelected: _currentIndex == 0,
                      bottomPadding: bottomPadding,
                      onPressed: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: MyPuttBottomNavItem(
                      iconData: FlutterRemix.record_circle_fill,
                      isSelected: _currentIndex == 1,
                      bottomPadding: bottomPadding,
                      onPressed: () {
                        setState(() {
                          _currentIndex = 1;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: MyPuttBottomNavItem(
                      iconData: FlutterRemix.sword_fill,
                      isSelected: _currentIndex == 2,
                      bottomPadding: bottomPadding,
                      onPressed: () {
                        setState(() {
                          _currentIndex = 2;
                        });
                      },
                    ),
                  ),
                  if (_eventsV1Beta)
                    Expanded(
                      child: MyPuttBottomNavItem(
                        iconData: FlutterRemix.medal_2_fill,
                        isSelected: _currentIndex == 3,
                        bottomPadding: bottomPadding,
                        onPressed: () {
                          setState(() {
                            _currentIndex = 3;
                          });
                        },
                      ),
                    ),
                  Expanded(
                    child: MyPuttBottomNavItem(
                      iconData: FlutterRemix.user_3_fill,
                      isSelected: _currentIndex == (_eventsV1Beta ? 4 : 3),
                      bottomPadding: bottomPadding,
                      onPressed: () {
                        setState(() {
                          _currentIndex = (_eventsV1Beta ? 4 : 3);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
