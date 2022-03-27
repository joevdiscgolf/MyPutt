import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/cubits/home_screen_cubit.dart';
import 'package:myputt/cubits/my_profile_cubit.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/screens/home/home_screen.dart';
import 'package:myputt/screens/my_profile/my_profile_screen.dart';
import 'package:myputt/screens/sessions/sessions_screen.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/screens/challenge/challenges_screen.dart';
import 'package:myputt/cubits/challenges_cubit.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({Key? key}) : super(key: key);

  static String routeName = '/';

  @override
  _MainWrapperState createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> screens = <Widget>[
    const HomeScreen(),
    const SessionsScreen(),
    const ChallengesScreen(),
    const MyProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[100]!,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        enableFeedback: true,
        onTap: (int index) {
          if (index == 0) {
            BlocProvider.of<HomeScreenCubit>(context).reloadStats();
          } else if (index == 1) {
            BlocProvider.of<SessionsCubit>(context).reload();
          } else if (index == 3) {
            BlocProvider.of<MyProfileCubit>(context).reload();
          }
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
          const BottomNavigationBarItem(
            icon: Icon(FlutterRemix.user_fill),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _challengesIcon(
      BuildContext context, List<PuttingChallenge> pendingChallenges) {
    return Stack(children: [
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
                    child: Text(pendingChallenges.length.toString(),
                        style: const TextStyle(
                            fontSize: 15, color: Colors.white))))),
      )
    ]);
  }
}
