import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/screens/home/home_screen.dart';
import 'package:myputt/screens/my_profile/my_profile_screen.dart';
import 'package:myputt/screens/sessions/sessions_screen.dart';

import '../challenge/challenges_screen.dart';

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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FlutterRemix.home_2_line),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FlutterRemix.record_circle_line),
            label: 'Record',
          ),
          BottomNavigationBarItem(
            icon: Icon(FlutterRemix.sword_line),
            label: 'Challenges',
          ),
          BottomNavigationBarItem(
            icon: Icon(FlutterRemix.user_line),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
