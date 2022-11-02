import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:myputt/utils/colors.dart';

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  }) : super(key: key);

  final Widget icon;
  final String title;
  final String subtitle;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {
        onPressed();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: MyPuttColors.gray[100]!,
            ),
          ),
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: MyPuttColors.darkGray,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        fontSize: 12,
                        color: MyPuttColors.gray[400],
                      ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
