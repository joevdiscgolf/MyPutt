import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/screens/record/tabs/record_tab/components/circle_icon_container.dart';
import 'package:myputt/utils/colors.dart';

class SelectNoConditionRow extends StatelessWidget {
  const SelectNoConditionRow({Key? key, required this.onPressed})
      : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {
        onPressed();
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            const CircleIconContainer(
              icon: Icon(FlutterRemix.close_circle_line),
            ),
            const SizedBox(width: 12),
            Text(
              'None',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: MyPuttColors.gray[800]!,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
