import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'colors.dart';

void displayBottomSheet(
  BuildContext context,
  Widget panel, {
  bool backgroundBarrierColor = true,
  Duration duration = const Duration(milliseconds: 200),
  Function? onDismiss,
  bool dismissible = true,
}) {
  showBarModalBottomSheet(
      barrierColor: backgroundBarrierColor
          ? MyPuttColors.darkGray.withOpacity(0.8)
          : Colors.transparent,
      context: context,
      duration: duration,
      enableDrag: dismissible,
      isDismissible: dismissible,
      topControl: Container(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (BuildContext context) => panel).then((_) {
    if (onDismiss != null) {
      onDismiss();
    }
  });
}
