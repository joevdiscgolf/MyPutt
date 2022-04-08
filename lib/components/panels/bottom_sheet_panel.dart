import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class BottomSheetPanel extends StatelessWidget {
  const BottomSheetPanel({
    Key? key,
    required this.child,
    this.backgroundColor = MyPuttColors.white,
    this.fullScreen = false,
  }) : super(key: key);

  final Widget child;
  final Color backgroundColor;
  final bool fullScreen;

  @override
  Widget build(BuildContext context) {
    final double panelHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        minHeight: fullScreen ? panelHeight : 200,
        maxHeight: panelHeight,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: fullScreen ? MediaQuery.of(context).padding.top : 8,
          bottom: 48,
        ),
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 24),
            child,
          ],
        ),
      ),
    );
  }
}
