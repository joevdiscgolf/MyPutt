import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myputt/screens/challenge_v2/components/tab_bar/challenge_category_v2_tab.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';

class ChallengesV2TabBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ChallengesV2TabBar({Key? key, required this.tabController})
      : super(key: key);

  final TabController tabController;

  @override
  Size get preferredSize => const Size.fromHeight(kTopNavBarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyPuttColors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: MyPuttColors.gray[400]!,
          ),
        ),
      ),
      child: TabBar(
        controller: tabController,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: MyPuttColors.blue),
        ),
        labelColor: MyPuttColors.blue,
        unselectedLabelColor: Colors.black,
        labelPadding: const EdgeInsets.only(top: 16, bottom: 8),
        onTap: (int index) {
          HapticFeedback.lightImpact();
        },
        tabs: const [
          ChallengeCategoryV2Tab(challengeCategory: ChallengeCategory.active),
          ChallengeCategoryV2Tab(challengeCategory: ChallengeCategory.pending),
          ChallengeCategoryV2Tab(challengeCategory: ChallengeCategory.complete),
        ],
      ),
    );
  }
}
