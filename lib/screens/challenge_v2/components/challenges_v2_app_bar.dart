import 'package:flutter/material.dart';
import 'package:myputt/screens/challenge_v2/components/tab_bar/challenge_v2_tab_bar.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/styles.dart';

class ChallengesV2AppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ChallengesV2AppBar(
      {Key? key, required this.topViewPadding, required this.tabController})
      : super(key: key);

  final double topViewPadding;
  final TabController tabController;

  @override
  Size get preferredSize =>
      Size.fromHeight(topViewPadding + kTopNavBarHeight + 48);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: topViewPadding),
      color: MyPuttColors.white,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 56,
            child: Text(
              'Challenges',
              style: MyPuttStyles.appBarTitleStyle(context),
            ),
          ),
          ChallengesV2TabBar(tabController: tabController)
        ],
      ),
    );
  }
}
