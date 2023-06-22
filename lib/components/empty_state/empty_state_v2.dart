import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class EmptyStateV2 extends StatelessWidget {
  const EmptyStateV2({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.iconData,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: MyPuttColors.black,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: MyPuttColors.gray[400],
                ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
