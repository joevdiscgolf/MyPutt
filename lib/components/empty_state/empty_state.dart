import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/retry_button.dart';
import 'package:myputt/utils/colors.dart';

class EmptyState extends StatefulWidget {
  const EmptyState(
      {Key? key,
      this.title = "Something went wrong",
      this.subtitle = "Please try again",
      required this.onRetry})
      : super(key: key);

  final String title;
  final String subtitle;
  final Function onRetry;

  @override
  State<EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState> {
  bool _continueLoading = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              widget.title,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontSize: 40, color: MyPuttColors.gray[600]),
              maxLines: 1,
            ),
            const SizedBox(
              height: 16,
            ),
            Icon(
              FlutterRemix.emotion_sad_fill,
              size: 100,
              color: MyPuttColors.gray[400]!,
            ),
            const SizedBox(
              height: 16,
            ),
            AutoSizeText(
              widget.subtitle,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontSize: 20, color: MyPuttColors.gray[400]),
            ),
            const SizedBox(height: 24),
            RetryButton(
              repeat: _continueLoading,
              onPressed: () async {
                await widget.onRetry();
                setState(() {
                  _continueLoading = false;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
