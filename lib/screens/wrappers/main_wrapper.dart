import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/challenge_v2/challenges_screen_v2.dart';
import 'package:myputt/screens/events/events_screen.dart';
import 'package:myputt/screens/home/home_screen.dart';
import 'package:myputt/screens/home_v2/home_screen_v2.dart';
import 'package:myputt/screens/my_profile/my_profile_screen.dart';
import 'package:myputt/screens/sessions/sessions_screen.dart';
import 'package:myputt/screens/challenge/challenges_screen.dart';
import 'package:myputt/screens/wrappers/components/main_wrapper_bottom_nav_bar.dart';
import 'package:myputt/services/beta_access_service.dart';
import 'package:myputt/services/navigation_service.dart';
import 'package:myputt/utils/constants/beta_access_constants.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({Key? key}) : super(key: key);

  static const String routeName = '/';

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final NavigationService _navigationService = locator.get<NavigationService>();
  int _currentIndex = 0;

  late final bool _eventsV1Beta;
  late final bool _homeScreenV2;
  late final bool _challengesV2Screen;

  late final StreamSubscription<int> _tabStreamSubscription;

  late final Map<String, Widget> _screenNameToScreen;

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

    final String homeScreenName =
        _homeScreenV2 ? HomeScreenV2.screenName : HomeScreen.screenName;
    final Widget homeScreenWidget =
        _homeScreenV2 ? const HomeScreenV2() : const HomeScreen();

    final String challengesScreenName = _homeScreenV2
        ? ChallengesScreenV2.screenName
        : ChallengesScreen.screenName;
    final Widget challengesScreenWidget = _challengesV2Screen
        ? const ChallengesScreenV2()
        : const ChallengesScreen();

    _screenNameToScreen = Map.fromEntries(
      [
        MapEntry(homeScreenName, homeScreenWidget),
        const MapEntry(SessionsScreen.screenName, SessionsScreen()),
        MapEntry(challengesScreenName, challengesScreenWidget),
        if (_eventsV1Beta)
          const MapEntry(EventsScreen.screenName, EventsScreen()),
        const MapEntry(MyProfileScreen.screenName, MyProfileScreen()),
      ],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _screenNameToScreen.values.toList(),
            ),
          ),
          MainWrapperBottomNavBar(
            screenNameToScreen: _screenNameToScreen,
            currentIndex: _currentIndex,
            updateCurrentIndex: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
