import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    this.backgroundColor = Colors.blue,
    this.labelColor = Colors.white,
    this.iconColor = Colors.white,
    this.height = 48,
    this.width = double.infinity,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.icon,
    this.gradientBackground,
    this.loading = false,
    this.disabled = false,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  final Color backgroundColor;
  final List<Color>? gradientBackground;
  final Color labelColor;
  final Color iconColor;
  final String label;
  final double fontSize;
  final FontWeight fontWeight;
  final double height;
  final double width;
  final IconData? icon;
  final Function onPressed;
  final bool loading;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      primary: gradientBackground?.isNotEmpty == true
          ? Colors.transparent
          : backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
      enableFeedback: true,
      shadowColor: Colors.transparent,
      elevation: 0,
      onPrimary: Colors.grey[100],
    );
    final Widget text = Text(
      label,
      maxLines: 1,
      style: Theme.of(context).textTheme.headline6!.copyWith(
            color: labelColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
            overflow: TextOverflow.ellipsis,
          ),
    );

    Widget button;
    if (icon != null && !loading) {
      button = ElevatedButton.icon(
        icon: Icon(icon, color: iconColor, size: 20),
        onPressed: (loading || disabled)
            ? null
            : () {
                Vibrate.feedback(FeedbackType.light);
                onPressed();
              },
        label: text,
        style: buttonStyle,
      );
    } else {
      button = ElevatedButton(
        onPressed: (loading || disabled)
            ? null
            : () {
                Vibrate.feedback(FeedbackType.light);
                onPressed();
              },
        child: loading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: labelColor),
              )
            : text,
        style: buttonStyle,
      );
    }

    return Bounceable(
      onTap: () => Vibrate.feedback(FeedbackType.light),
      child: Container(
        height: height,
        width: width,
        decoration: gradientBackground != null
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(48),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientBackground!,
                  stops: const [0.0, 1.0],
                ),
              )
            : null,
        child: button,
      ),
    );
  }
}
