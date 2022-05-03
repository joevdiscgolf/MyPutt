import 'package:flutter/material.dart';
import 'package:myputt/components/buttons/app_bar_back_button.dart';

class EventDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EventDetailAppBar({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Expanded(
            child: Align(
                alignment: Alignment.centerLeft, child: AppBarBackButton()),
          ),
          Text(title),
          const Spacer()
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
