import 'package:flutter/material.dart';
import 'package:myputt/components/buttons/app_bar_back_button.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/styles.dart';

class MyPuttAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyPuttAppBar({
    Key? key,
    required this.title,
    this.hasBackButton = true,
    this.icon,
    this.controller,
  }) : super(key: key);

  final String title;
  final bool hasBackButton;
  final Widget? icon;
  final ScrollController? controller;

  @override
  Size get preferredSize => const Size.fromHeight(kTopNavBarHeight);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller != null
          ? () {
              controller?.animateTo(
                0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuart,
              );
            }
          : null,
      child: Container(
        color: Colors.transparent,
        height: kTopNavBarHeight + MediaQuery.of(context).viewPadding.top,
        padding: const EdgeInsets.only(top: kTopNavBarHeight),
        child: Row(
          children: [
            Expanded(
              child: hasBackButton
                  ? Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 16),
                      child: const AppBarBackButton(),
                    )
                  : const SizedBox(),
            ),
            Text(
              title,
              style: MyPuttStyles.appBarTitleStyle(context),
            ),
            Expanded(child: icon ?? const SizedBox()),
          ],
        ),
      ),
    );
  }
}
