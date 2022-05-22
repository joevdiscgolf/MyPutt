import 'package:flutter/material.dart';
import 'package:myputt/components/panels/bottom_sheet_panel.dart';
import 'package:myputt/utils/colors.dart';

class InfoPanel extends StatelessWidget {
  const InfoPanel({Key? key, required this.headerText, required this.bodyText})
      : super(key: key);

  final String headerText;
  final String bodyText;

  @override
  Widget build(BuildContext context) {
    return BottomSheetPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headerText,
            style: Theme.of(context).textTheme.headline6?.copyWith(
                color: MyPuttColors.darkGray,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            bodyText,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: MyPuttColors.darkGray, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
