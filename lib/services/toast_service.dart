import 'dart:async';
import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class ToastData {
  ToastData({required this.message, this.icon});
  final String message;
  final Widget? icon;
}

class ToastService {
  ToastService() {
    toastDataStream = _toastDataController.stream.asBroadcastStream();
  }

  static const double _leftPadding = 12;
  static const double _verticalPadding = 12;
  static const double _innerToastSpacing = 8;
  static const double _iconSize = 24;

  final StreamController<ToastData> _toastDataController = StreamController();
  late final Stream<ToastData> toastDataStream;

  void triggerToast(String message, {Widget? icon}) {
    _toastDataController.add(ToastData(message: message, icon: icon));
  }

  Flushbar getGenericToast(
    BuildContext context,
    ToastData toastData, {
    required Function onTap,
    Key? key,
  }) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;

    final double textWidth = _getTextWidth(
      toastData.message,
      _getTextStyle(context, darkMode),
    );

    final double rightPadding = toastData.icon != null ? 16 : 12;

    double maxWidth = textWidth + _leftPadding + rightPadding;

    if (toastData.icon != null) {
      maxWidth += _innerToastSpacing + _iconSize;
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
        right: rightPadding,
        top: _verticalPadding,
        bottom: _verticalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (toastData.icon != null) ...[
            SizedBox(
              width: _iconSize,
              child: toastData.icon!,
            ),
            const SizedBox(width: _innerToastSpacing),
          ],
          Expanded(
            child: Text(
              toastData.message,
              style: Theme.of(context).textTheme.subtitle2?.copyWith(
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
    return Theme.of(context).textTheme.subtitle2!.copyWith(
          color: darkMode ? MyPuttColors.gray[800] : MyPuttColors.white,
          fontWeight: FontWeight.w500,
        );
  }

  Flushbar customFlushBar(
    BuildContext context, {
    Key? key,
    required double maxWidth,
    required Widget child,
    EdgeInsets padding = const EdgeInsets.only(
      left: _leftPadding,
      right: 12,
      top: _verticalPadding,
      bottom: _verticalPadding,
    ),
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
      onTap: (_) {
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
