import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
      title: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.headlineMedium,
            children: [
              const TextSpan(text: 'My', style: TextStyle(color: Colors.blue)),
              TextSpan(
                  text: 'Putt',
                  style: TextStyle(color: MyPuttColors.gray[400])),
            ],
          ),
        ),
      ),
    );
  }
}
