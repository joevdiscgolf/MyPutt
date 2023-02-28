import 'package:flutter/widgets.dart';
import 'package:myputt/utils/colors.dart';

bool hasTopPadding(BuildContext context) =>
    MediaQuery.of(context).viewPadding.top > 0;

List<BoxShadow> standardBoxShadow() {
  return [
    BoxShadow(
      offset: const Offset(0, 2),
      color: MyPuttColors.black.withOpacity(0.25),
      blurRadius: 2,
      spreadRadius: 0,
    )
  ];
}
