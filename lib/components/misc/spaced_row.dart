import 'package:flutter/material.dart';
import 'package:myputt/utils/layout_helpers.dart';

class SpacedRow extends StatelessWidget {
  const SpacedRow({Key? key, required this.children, this.runSpacing = 8})
      : super(key: key);

  final List<Widget> children;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return Row(children: addRunSpacing(children));
  }
}
