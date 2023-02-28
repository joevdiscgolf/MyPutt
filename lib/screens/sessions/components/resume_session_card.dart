import 'package:flutter/material.dart';
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
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 28),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: standardBoxShadow(),
              color: MyPuttColors.gray[50]!,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Resume session',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
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
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16, right: 16),
                    child: Icon(FlutterRemix.arrow_right_s_line),
                  )
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(24, -12),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: standardBoxShadow(),
                  color: MyPuttColors.gray[400],
                ),
                child: const Icon(
                  FlutterRemix.play_line,
                  color: MyPuttColors.white,
                  size: 24,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
