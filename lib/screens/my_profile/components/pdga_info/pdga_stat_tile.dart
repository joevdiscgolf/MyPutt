import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class PdgaStatTile extends StatelessWidget {
  const PdgaStatTile(
      {Key? key, required this.description, this.value, required this.iconData})
      : super(key: key);

  final String description;
  final String? value;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: MyPuttColors.gray[50]!,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 2,
                color: MyPuttColors.gray[400]!)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            iconData,
            color: MyPuttColors.darkGray,
            size: 20,
          ),
          const SizedBox(height: 2),
          AutoSizeText(
            value ?? 'N/A',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: MyPuttColors.darkGray, fontSize: 16),
            maxLines: 1,
          ),
          const SizedBox(height: 2),
          AutoSizeText(
            description,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: MyPuttColors.gray[400], fontSize: 12),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
