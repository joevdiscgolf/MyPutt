import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/utils/colors.dart';

class PuttTypeChip extends StatelessWidget {
  const PuttTypeChip({Key? key, this.puttType}) : super(key: key);

  final PuttType? puttType;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 116,
        decoration: BoxDecoration(
          color: MyPuttColors.gray[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Putt type',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 16)),
            AutoSizeText(
              puttType == null ? 'Select' : puttType!.name,
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: puttType == null
                        ? MyPuttColors.blue
                        : MyPuttColors.darkGray,
                  ),
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }
}
