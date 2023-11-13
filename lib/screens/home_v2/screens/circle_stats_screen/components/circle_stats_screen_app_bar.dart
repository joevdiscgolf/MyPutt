import 'package:flutter/material.dart';
import 'package:myputt/components/buttons/app_bar_back_button.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';

class CircleStatsScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CircleStatsScreenAppBar({Key? key, required this.circle})
      : super(key: key);

  final PuttingCircle circle;

  @override
  Size get preferredSize => const Size.fromHeight(kTopNavBarHeight);

  @override
  Widget build(BuildContext context) {
    final double topViewPadding = MediaQuery.of(context).viewPadding.top;
    return Container(
      padding: EdgeInsets.only(top: topViewPadding),
      height: kTopNavBarHeight + topViewPadding,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              child: const AppBarBackButton(),
            ),
          ),
          Text(
            '${kCircleToNameMap[circle]}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  color: MyPuttColors.blue,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
