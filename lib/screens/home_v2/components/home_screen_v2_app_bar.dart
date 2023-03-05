import 'package:flutter/material.dart';
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
    final TextStyle? textStyle =
        Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 20,
              color: MyPuttColors.gray[800],
              fontWeight: FontWeight.w800,
            );
    return Padding(
      padding: EdgeInsets.only(top: topViewPadding),
      // alignment: Alignment.center,
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.headlineMedium,
            children: [
              TextSpan(
                text: 'My',
                style: textStyle,
              ),
              TextSpan(
                text: 'Putt',
                style: textStyle?.copyWith(color: MyPuttColors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
