import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/events/events_screen.dart';
import 'package:myputt/screens/home/home_screen.dart';
import 'package:myputt/screens/my_profile/my_profile_screen.dart';
import 'package:myputt/screens/sessions/sessions_screen.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/screens/challenge/challenges_screen.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/services/beta_access_service.dart';
import 'package:myputt/services/navigation_service.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({Key? key}) : super(key: key);

  static String routeName = '/';

  @override
  _MainWrapperState createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final NavigationService _navigationService = locator.get<NavigationService>();
  final Mixpanel _mixpanel = locator.get<Mixpanel>();
  int _currentIndex = 0;

  late final List<Widget> _screens;
  late bool _showEventsTab;

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
    _screens = <Widget>[
      const HomeScreen(),
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
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[100]!,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        enableFeedback: true,
        onTap: (int index) {
          Vibrate.feedback(FeedbackType.light);
          _mixpanel.track(
            'Bottom Navigation Bar Item Pressed',
            properties: {'Screen': _screens[index].toString()},
          );
          setState(() => _currentIndex = index);
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(FlutterRemix.home_2_fill),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(FlutterRemix.record_circle_fill),
            label: 'Record',
          ),
          BottomNavigationBarItem(
            icon: BlocBuilder<ChallengesCubit, ChallengesState>(
              builder: (context, state) {
                if (state is ChallengeInProgress) {
                  return _challengesIcon(context, state.pendingChallenges);
                }
                if (state is CurrentUserComplete) {
                  return _challengesIcon(context, state.pendingChallenges);
                }
                if (state is NoCurrentChallenge) {
                  return _challengesIcon(context, state.pendingChallenges);
                } else {
                  return const Icon(FlutterRemix.sword_fill);
                }
              },
            ),
            label: 'Challenge',
          ),
          if (_showEventsTab)
            const BottomNavigationBarItem(
              icon: Icon(FlutterRemix.medal_2_fill),
              label: 'Events',
            ),
          const BottomNavigationBarItem(
            icon: Icon(FlutterRemix.user_3_fill),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _challengesIcon(
      BuildContext context, List<PuttingChallenge> pendingChallenges) {
    return Stack(
      children: [
        const Center(child: Icon(FlutterRemix.sword_fill)),
        Visibility(
          visible: pendingChallenges.isNotEmpty,
          child: Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  pendingChallenges.length.toString(),
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
