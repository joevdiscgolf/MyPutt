import 'package:flutter/material.dart';
import 'package:myputt/screens/home_v2/components/home_screen_v2_app_bar/myputt_rich_text.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';

class HomeScreenV2AppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const HomeScreenV2AppBar({Key? key, required this.topViewPadding})
      : super(key: key);

  final double topViewPadding;

  @override
  Size get preferredSize => const Size.fromHeight(kTopNavBarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyPuttColors.gray[700],
      padding: EdgeInsets.only(top: topViewPadding),
      child: Container(
        padding: const EdgeInsets.only(left: 16),
        height: kTopNavBarHeight,
        alignment: Alignment.centerLeft,
        child: const MyPuttRichText(),
      ),
    );
  }
}
