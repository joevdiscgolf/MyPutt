import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/layout_helpers.dart';

class ResumeSessionCard extends StatelessWidget {
  const ResumeSessionCard({Key? key, required this.currentSession})
      : super(key: key);

  final PuttingSession currentSession;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, top: 80),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: standardBoxShadow(),
        color: MyPuttColors.gray[50]!,
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resume session',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: MyPuttColors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '11 sets, 96 putts',
                        style: Theme.of(context).textTheme.titleSmall,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: const Icon(FlutterRemix.arrow_right_s_line),
              )
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: standardBoxShadow(),
                color: MyPuttColors.gray[50],
              ),
              child: Icon(
                FlutterRemix.play_line,
                color: MyPuttColors.blue,
              ),
            ),
          )
        ],
      ),
    );
  }
}
