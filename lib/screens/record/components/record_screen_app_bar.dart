import 'package:flutter/material.dart';
import 'package:myputt/components/buttons/app_bar_back_button.dart';
import 'package:myputt/screens/record/components/finish_session_button.dart';
import 'package:myputt/utils/colors.dart';

class RecordScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const RecordScreenAppBar({
    Key? key,
    required this.tabController,
    required this.topViewPadding,
  }) : super(key: key);

  final TabController tabController;
  final double topViewPadding;
  static const double tabBarHeight = 48;

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topViewPadding),
      child: Column(
        children: [
          Row(
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
          SizedBox(
            height: tabBarHeight,
            child: TabBar(
              controller: tabController,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(color: MyPuttColors.darkGray),
              ),
              tabs: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Record',
                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                          color: tabController.index == 0
                              ? MyPuttColors.darkGray
                              : MyPuttColors.gray[300],
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Sets',
                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                          color: tabController.index == 0
                              ? MyPuttColors.darkGray
                              : MyPuttColors.gray[300],
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
