import 'package:flutter/material.dart';
import 'package:myputt/components/buttons/app_bar_back_button.dart';
import 'package:myputt/screens/record/components/finish_session_button.dart';
import 'package:myputt/screens/record/components/record_screen_tab_bar.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';

class RecordScreenAppBar extends StatefulWidget implements PreferredSizeWidget {
  const RecordScreenAppBar({
    Key? key,
    required this.tabController,
    required this.topViewPadding,
  }) : super(key: key);

  final TabController tabController;
  final double topViewPadding;
  static const double tabBarHeight = 48;

  @override
  Size get preferredSize => const Size.fromHeight(kNavBarHeight + tabBarHeight);

  @override
  State<RecordScreenAppBar> createState() => _RecordScreenAppBarState();
}

class _RecordScreenAppBarState extends State<RecordScreenAppBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.topViewPadding),
      child: Column(
        children: [
          SizedBox(
            height: kNavBarHeight,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 16),
                    alignment: Alignment.centerLeft,
                    child: const AppBarBackButton(),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Record',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontSize: 20,
                          color: MyPuttColors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(right: 24),
                    alignment: Alignment.centerRight,
                    child: const FinishSessionButton(),
                  ),
                ),
              ],
            ),
          ),
          RecordScreenTabBar(tabController: widget.tabController),
        ],
      ),
    );
  }
}
