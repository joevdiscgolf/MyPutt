import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/screens/home/home_screen.dart';
import 'package:myputt/screens/my_profile/my_profile_screen.dart';
import 'package:myputt/screens/sessions/sessions_screen.dart';
import '../../data/types/challenges/putting_challenge.dart';
import '../challenge/challenges_screen.dart';
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
          setState(() => _currentIndex = index);
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(FlutterRemix.home_2_line),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(FlutterRemix.record_circle_line),
            label: 'Record',
          ),
          BottomNavigationBarItem(
            icon: BlocBuilder<ChallengesCubit, ChallengesState>(
              builder: (context, state) {
                if (state is ChallengeInProgress) {
                  return _challengesIcon(context, state.pendingChallenges);
                }
                if (state is ChallengeComplete) {
                  return _challengesIcon(context, state.pendingChallenges);
                }
                if (state is NoCurrentChallenge) {
                  return _challengesIcon(context, state.pendingChallenges);
                } else {
                  return const Icon(FlutterRemix.sword_line);
                }
              },
            ),
            label: 'Challenges',
          ),
          const BottomNavigationBarItem(
            icon: Icon(FlutterRemix.user_line),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _challengesIcon(
      BuildContext context, List<PuttingChallenge> pendingChallenges) {
    return SizedBox(
      height: 40,
      width: 40,
      child: Stack(children: [
        Center(child: const Icon(FlutterRemix.sword_line)),
        Visibility(
          visible: pendingChallenges.isNotEmpty,
          child: Positioned(
              top: 0,
              right: 0,
              child: Container(
                  padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                  decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle),
                  child: Center(
                      child: Text(pendingChallenges.length.toString(),
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white))))),
        )
      ]),
    );
  }
}
