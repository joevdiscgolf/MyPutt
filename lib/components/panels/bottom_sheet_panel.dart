import 'package:flutter/material.dart';
import 'package:myputt/components/misc/panel_sliding_indicator.dart';
import 'package:myputt/utils/colors.dart';

class BottomSheetPanel extends StatelessWidget {
  const BottomSheetPanel({
    Key? key,
    required this.child,
    this.backgroundColor = MyPuttColors.white,
    this.fullScreen = false,
    this.hasSlidingIndicator = false,
    this.scrollViewPadding,
  }) : super(key: key);

  final Widget child;
  final Color backgroundColor;
  final bool fullScreen;
  final bool hasSlidingIndicator;
  final EdgeInsetsGeometry? scrollViewPadding;

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
        padding: scrollViewPadding ??
            EdgeInsets.only(
              top: fullScreen ? MediaQuery.of(context).padding.top : 8,
              bottom: 48,
            ),
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (hasSlidingIndicator)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: PanelSlidingIndicator(),
              ),
            const SizedBox(height: 24),
            child,
          ],
        ),
      ),
    );
  }
}
