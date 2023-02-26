import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/utils/colors.dart';

class SessionsScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SessionsScreenAppBar({Key? key, required this.scrollController})
      : super(key: key);

  final ScrollController scrollController;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuart,
        );
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: Center(
          child: Text(
            'Sessions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  color: MyPuttColors.blue,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
