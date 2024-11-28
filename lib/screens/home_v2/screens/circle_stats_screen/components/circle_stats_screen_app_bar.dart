import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/buttons/app_bar_back_button.dart';
import 'package:myputt/cubits/home/home_screen_cubit.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';

class CircleStatsScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CircleStatsScreenAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kTopNavBarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, homeScreenState) {
        final double topViewPadding = MediaQuery.of(context).viewPadding.top;
        return Container(
          padding: EdgeInsets.only(top: topViewPadding),
          height: kTopNavBarHeight + topViewPadding,
          color: MyPuttColors.gray[700],
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 16),
                  alignment: Alignment.centerLeft,
                  child: const AppBarBackButton(color: MyPuttColors.white),
                ),
              ),
              Text(
                '${kCircleToNameMap[homeScreenState.selectedCircle]}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      color: MyPuttColors.blue,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _circleButtons(context, homeScreenState.selectedCircle),
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _circleButtons(BuildContext context, PuttingCircle selectedCircle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ...[PuttingCircle.c1, PuttingCircle.c2, PuttingCircle.c3].map(
          (PuttingCircle circle) => _circleButton(
            context,
            circle,
            isFirst: circle == PuttingCircle.c1,
            isLast: circle == PuttingCircle.c3,
            isSelected: circle == selectedCircle,
          ),
        ),
      ],
    );
  }

  Widget _circleButton(
    BuildContext context,
    PuttingCircle circle, {
    bool isFirst = false,
    bool isLast = false,
    bool isSelected = false,
  }) {
    return Bounceable(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
        BlocProvider.of<HomeScreenCubit>(context).updateSelectedCircle(circle);
      },
      child: Container(
        alignment: Alignment.center,
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: MyPuttColors.gray[isSelected ? 600 : 800],
          borderRadius: BorderRadius.only(
            topLeft: isFirst ? const Radius.circular(8) : Radius.zero,
            bottomLeft: isFirst ? const Radius.circular(8) : Radius.zero,
            topRight: isLast ? const Radius.circular(8) : Radius.zero,
            bottomRight: isLast ? const Radius.circular(8) : Radius.zero,
          ),
        ),
        child: Text(
          kCircleToShortNameMap[circle]!,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: MyPuttColors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
