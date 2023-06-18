import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/screens/challenge/challenges_screen.dart';
import 'package:myputt/screens/challenge_v2/challenges_screen_v2.dart';
import 'package:myputt/screens/events/events_screen.dart';
import 'package:myputt/screens/home/home_screen.dart';
import 'package:myputt/screens/home_v2/home_screen_v2.dart';
import 'package:myputt/screens/my_profile/my_profile_screen.dart';
import 'package:myputt/screens/sessions/sessions_screen.dart';
import 'package:myputt/screens/wrappers/components/main_wrapper_bottom_nav_item.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/layout_helpers.dart';

class MainWrapperBottomNavBar extends StatelessWidget {
  const MainWrapperBottomNavBar({
    Key? key,
    required this.screenNameToScreen,
    required this.currentIndex,
    required this.updateCurrentIndex,
  }) : super(key: key);

  final Map<String, Widget> screenNameToScreen;
  final int currentIndex;
  final Function(int) updateCurrentIndex;

  static const Map<String, IconData> _screenNameToIconData = {
    HomeScreen.screenName: FlutterRemix.home_2_fill,
    HomeScreenV2.screenName: FlutterRemix.home_2_fill,
    SessionsScreen.screenName: FlutterRemix.record_circle_fill,
    ChallengesScreen.screenName: FlutterRemix.sword_fill,
    ChallengesScreenV2.screenName: FlutterRemix.sword_fill,
    EventsScreen.screenName: FlutterRemix.medal_2_fill,
    MyProfileScreen.screenName: FlutterRemix.user_3_fill,
  };

  @override
  Widget build(BuildContext context) {
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
                children: screenNameToScreen.keys.mapIndexed(
                  (int index, String screenName) {
                    return Expanded(
                      child: MainWrapperBottomNavItem(
                        iconData: _screenNameToIconData[screenName] ??
                            FlutterRemix.home_2_fill,
                        isSelected: currentIndex == index,
                        bottomPadding: bottomPadding,
                        onPressed: () {
                          updateCurrentIndex(index);
                        },
                      ),
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
