import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class SelectionTile extends StatelessWidget {
  const SelectionTile({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: MyPuttColors.gray[50],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: MyPuttColors.black.withOpacity(0.25),
            offset: const Offset(0, 2),
            blurRadius: 2,
            spreadRadius: 0,
          )
        ],
      ),
      child: child,
    );
  }
}
