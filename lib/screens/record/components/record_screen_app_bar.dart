import 'package:flutter/material.dart';
import 'package:myputt/components/buttons/app_bar_back_button.dart';
import 'package:myputt/utils/colors.dart';

class RecordScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const RecordScreenAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).viewPadding.top,
      ),
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
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
