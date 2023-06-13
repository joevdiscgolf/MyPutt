import 'dart:async';
import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:myputt/components/misc/myputt_error_icon.dart';
import 'package:myputt/services/toast/toast_data.dart';
import 'package:myputt/utils/colors.dart';

class ToastService {
  ToastService() {
    toastDataStream = _toastDataController.stream.asBroadcastStream();
  }

  static const double _leftPadding = 12;
  static const double _rightPadding = 16;
  static const double _verticalPadding = 12;
  static const double _innerToastSpacing = 8;

  final StreamController<ToastData> _toastDataController = StreamController();
  late final Stream<ToastData> toastDataStream;

  void triggerGenericToast(GenericToastMetadata metadata) {
    _toastDataController.add(
      ToastData(
        toastType: ToastType.generic,
        metadata: metadata,
      ),
    );
  }

  void triggerErrorToast(String error) {
    _toastDataController.add(
      ToastData(
        toastType: ToastType.generic,
        metadata: GenericToastMetadata(
          icon: const MyPuttErrorIcon(),
          message: error,
        ),
      ),
    );
  }

  void triggerEditFailedToast() {
    _toastDataController.add(ToastData(
      toastType: ToastType.generic,
      metadata: GenericToastMetadata(
        icon: const MyPuttErrorIcon(),
        message: "Updates weren't saved",
      ),
    ));
  }

  void triggerDeleteFailedToast() {
    _toastDataController.add(ToastData(
      toastType: ToastType.generic,
      metadata: GenericToastMetadata(
        icon: const MyPuttErrorIcon(),
        message: "Couldn't delete asset",
      ),
    ));
  }

  void triggerDefaultErrorToast() {
    _toastDataController.add(
      ToastData(
        toastType: ToastType.generic,
        metadata: GenericToastMetadata(
          icon: const MyPuttErrorIcon(),
          message: "Something went wrong",
        ),
      ),
    );
  }

  void triggerSuccessToast(
    String message,
    IconData iconData,
    Color iconColor,
    double width,
  ) {
    _toastDataController.add(
      ToastData(
        toastType: ToastType.generic,
        metadata: GenericToastMetadata(
          icon: Icon(
            iconData,
            color: iconColor,
            size: 24,
          ),
          message: message,
        ),
      ),
    );
  }

  Flushbar getGenericToast(
    BuildContext context,
    GenericToastMetadata genericToastMetadata, {
    required Function onTap,
    Key? key,
  }) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;

    final double textWidth = _getTextWidth(
      genericToastMetadata.message,
      _getTextStyle(context, darkMode),
    );

    double maxWidth = textWidth + _leftPadding + _rightPadding;

    if (genericToastMetadata.icon != null) {
      maxWidth += genericToastMetadata.iconSize + _innerToastSpacing;
    }

    return customFlushBar(
      context,
      onTap: () {
        onTap();
      },
      key: key,
      duration: const Duration(seconds: 5),
      maxWidth: maxWidth,
      padding: EdgeInsets.only(
        left: _leftPadding,
        right: genericToastMetadata.icon != null ? _rightPadding : 12,
        top: _verticalPadding,
        bottom: _verticalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (genericToastMetadata.icon != null) ...[
            SizedBox(
              width: genericToastMetadata.iconSize,
              child: genericToastMetadata.icon!,
            ),
            const SizedBox(width: _innerToastSpacing),
          ],
          Expanded(
            child: Text(
              genericToastMetadata.message,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color:
                        darkMode ? MyPuttColors.gray[800] : MyPuttColors.white,
                    fontWeight: FontWeight.w500,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: darkMode ? MyPuttColors.white : MyPuttColors.gray[800]!,
      position: FlushbarPosition.TOP,
    );
  }

  double _getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width;
  }

  TextStyle _getTextStyle(BuildContext context, bool darkMode) {
    return Theme.of(context).textTheme.titleSmall!.copyWith(
          color: darkMode ? MyPuttColors.gray[800] : MyPuttColors.white,
          fontWeight: FontWeight.w500,
        );
  }

  Flushbar customFlushBar(
    BuildContext context, {
    Key? key,
    required double maxWidth,
    required Widget child,
    EdgeInsets padding = const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
    Duration duration = const Duration(seconds: 3),
    FlushbarPosition position = FlushbarPosition.BOTTOM,
    Color backgroundColor = MyPuttColors.white,
    Function? onTap,
  }) {
    return Flushbar(
      key: key,
      boxShadows: const [
        BoxShadow(
          color: MyPuttColors.shadowColor,
          offset: Offset(0.0, 6.0),
          blurRadius: 20,
        ),
      ],
      flushbarPosition: position,
      maxWidth: maxWidth,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: padding,
      borderRadius: BorderRadius.circular(48),
      backgroundColor: backgroundColor,
      isDismissible: true,
      duration: duration,
      animationDuration: const Duration(milliseconds: 400),
      forwardAnimationCurve: const SpringCurve(),
      reverseAnimationCurve: Curves.fastOutSlowIn,
      messageText: child,
      onTap: (Flushbar<dynamic> flushbar) {
        if (onTap != null) {
          onTap();
        }
      },
    );
  }
}

class SpringCurve extends Curve {
  const SpringCurve({this.a = 0.25, this.w = 2.5});

  final double a;
  final double w;

  @override
  double transformInternal(double t) {
    return -(pow(e, -t / a)) * cos(t * w) + 1;
  }
}
