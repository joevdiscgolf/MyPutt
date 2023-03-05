import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/locator.dart';
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
  late final bool _showEventsTab;
  late final bool _homeScreenV2;

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
    _showEventsTab = locator
        .get<BetaAccessService>()
        .hasFeatureAccess(featureName: 'events');
    _homeScreenV2 = locator
        .get<BetaAccessService>()
        .hasFeatureAccess(featureName: 'homeScreenV2');
    _screens = <Widget>[
      _homeScreenV2 ? const HomeScreenV2() : const HomeScreen(),
      const SessionsScreen(),
      const ChallengesScreen(),
      if (_showEventsTab) const EventsScreen(),
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
                      iconData: FlutterRemix.home_2_line,
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
                      iconData: FlutterRemix.record_circle_line,
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
                      iconData: FlutterRemix.sword_line,
                      isSelected: _currentIndex == 2,
                      bottomPadding: bottomPadding,
                      onPressed: () {
                        setState(() {
                          _currentIndex = 2;
                        });
                      },
                    ),
                  ),
                  if (_showEventsTab)
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
                      iconData: FlutterRemix.user_3_line,
                      isSelected: _currentIndex == (_showEventsTab ? 4 : 3),
                      bottomPadding: bottomPadding,
                      onPressed: () {
                        setState(() {
                          _currentIndex = (_showEventsTab ? 4 : 3);
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

  // Widget _challengesIcon(
  //     BuildContext context, List<PuttingChallenge> pendingChallenges) {
  //   return Stack(
  //     children: [
  //       const Center(child: Icon(FlutterRemix.sword_fill)),
  //       Visibility(
  //         visible: pendingChallenges.isNotEmpty,
  //         child: Positioned(
  //           top: 0,
  //           right: 0,
  //           child: Container(
  //             padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
  //             decoration: const BoxDecoration(
  //               color: Colors.red,
  //               shape: BoxShape.circle,
  //             ),
  //             child: Center(
  //               child: Text(
  //                 pendingChallenges.length.toString(),
  //                 style: const TextStyle(fontSize: 15, color: Colors.white),
  //               ),
  //             ),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }
}
