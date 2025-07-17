import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

bool hasTopPadding(BuildContext context) =>
    MediaQuery.of(context).viewPadding.top > 0;

List<BoxShadow> standardBoxShadow() {
  return [
    BoxShadow(
      offset: const Offset(0, 2),
      color: MyPuttColors.black.withValues(alpha: 0.25),
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

double bottomNavBarPadding(BuildContext context) {
  return MediaQuery.of(context).viewPadding.bottom > 0 ? 36 : 16;
}

List<Widget> addRunSpacing(
  List<Widget> children, {
  double runSpacing = 8,
  Axis axis = Axis.horizontal,
}) {
  final Widget spacerWidget = axis == Axis.horizontal
      ? SizedBox(width: runSpacing)
      : SizedBox(height: runSpacing);
  final List<Widget> spacedChildren = [];
  for (int i = 0; i < children.length; i++) {
    spacedChildren.add(children[i]);
    if (i < children.length - 1) {
      spacedChildren.add(spacerWidget);
    }
  }
  return spacedChildren;
}

double getTextWidth(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size.width;
}

List<Widget> spacedChildren(
  Iterable<Widget> children, {
  double spacing = 16,
  Axis axis = Axis.horizontal,
}) {
  final List<Widget> childrenList = children.toList();
  final List<Widget> spacedChildren = [];
  for (int i = 0; i < childrenList.length; i++) {
    spacedChildren.addAll(
      [
        childrenList[i],
        if (i < children.length - 1)
          SizedBox(
            height: axis == Axis.horizontal ? 0 : spacing,
            width: axis == Axis.horizontal ? spacing : 0,
          )
      ],
    );
  }
  return spacedChildren;
}
