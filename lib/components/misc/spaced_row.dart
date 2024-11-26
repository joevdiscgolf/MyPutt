import 'package:flutter/material.dart';
import 'package:myputt/utils/layout_helpers.dart';

class SpacedRow extends StatelessWidget {
  const SpacedRow({
    Key? key,
    required this.children,
    this.runSpacing = 8,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
  }) : super(key: key);

  final List<Widget> children;
  final double runSpacing;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: addRunSpacing(children, runSpacing: runSpacing),
    );
  }
}
