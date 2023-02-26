import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/utils/colors.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    Key? key,
    this.icon,
    this.title = "Whoops, connection error",
    this.subtitle = 'Please try again',
    this.subtitleColor,
    this.onRetry,
    this.refreshLabel = 'Reload',
  }) : super(key: key);

  final Widget? icon;
  final String title;
  final String subtitle;
  final Color? subtitleColor;
  final Function? onRetry;
  final String refreshLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? icon!
                : Icon(
                    FlutterRemix.thunderstorms_line,
                    color: MyPuttColors.gray[200],
                    size: 48,
                  ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              maxLines: 2,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: subtitleColor ?? Theme.of(context).primaryColorDark),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null)
              const SizedBox(
                height: 12,
              ),
            if (onRetry != null)
              Bounceable(
                onTap: () {
                  Vibrate.feedback(FeedbackType.light);
                  onRetry!();
                },
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      backgroundColor: MyPuttColors.gray[100],
                      shadowColor: Colors.transparent),
                  onPressed: () => onRetry != null ? onRetry!() : {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          IconData(
                            0xe514,
                            fontFamily: 'MaterialIcons',
                          ),
                          size: 20,
                          color: MyPuttColors.black,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          refreshLabel,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
