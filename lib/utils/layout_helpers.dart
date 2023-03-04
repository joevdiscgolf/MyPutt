import 'package:flutter/material.dart';
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

List<Widget> addDividers(
  List<Widget> children, {
  double padding = 0,
  bool includeLastDivider = false,
  double height = 1,
  double thickness = 1,
}) {
  List<Widget> withDividers = [];
  for (int i = 0; i < children.length; i++) {
    withDividers.add(children[i]);

    final int numDividers =
        includeLastDivider ? children.length : children.length - 1;

    if (i < numDividers) {
      withDividers.add(
        Center(
          child: Divider(
            color: MyPuttColors.gray[50]!,
            thickness: thickness,
            height: height,
            endIndent: padding,
            indent: padding,
          ),
        ),
      );
    }
  }
  return withDividers;
}
