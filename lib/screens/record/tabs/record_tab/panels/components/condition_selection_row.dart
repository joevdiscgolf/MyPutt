import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:myputt/screens/record/tabs/record_tab/components/circle_icon_container.dart';
import 'package:myputt/utils/colors.dart';

class ConditionSelectionRow extends StatelessWidget {
  const ConditionSelectionRow({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  final Function onPressed;
  final Widget icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {
        onPressed();
      },
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            CircleIconContainer(icon: icon),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: MyPuttColors.gray[800]!,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      subtitle!,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: MyPuttColors.gray[400]!),
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
