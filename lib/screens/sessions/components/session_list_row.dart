import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/components/misc/custom_circular_progress_indicator.dart';
import 'package:myputt/cubits/session_summary_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/screens/session_summary/session_summary_screen.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/layout_helpers.dart';
import 'package:myputt/utils/string_helpers.dart';

class SessionListRow extends StatelessWidget {
  const SessionListRow({Key? key, required this.session}) : super(key: key);

  final PuttingSession session;

  @override
  Widget build(BuildContext context) {
    final int setCount = session.sets.length;
    final int puttsAttempted = totalAttemptsFromSets(session.sets);
    final int puttsMade = totalMadeFromSets(session.sets);

    return Bounceable(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
        locator
            .get<Mixpanel>()
            .track('Sessions Screen Session Row Pressed', properties: {
          'Set Count': session.sets.length,
        });
        BlocProvider.of<SessionSummaryCubit>(context)
            .openSessionSummary(session);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) =>
                SessionSummaryScreen(session: session),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          boxShadow: standardBoxShadow(),
          borderRadius: BorderRadius.circular(8),
          color: MyPuttColors.white,
        ),
        child: Row(
          children: [
            SizedBox(
              height: 52,
              width: 52,
              child: CustomCircularProgressIndicator(
                percentage:
                    puttsAttempted == 0 ? 0 : puttsMade / puttsAttempted,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timestampToDate(session.timeStamp),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$setCount ${setCount == 1 ? 'set' : 'sets'}, $puttsAttempted ${puttsAttempted == 1 ? 'putt' : 'putts'}',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: MyPuttColors.gray[400]),
                  )
                ],
              ),
            ),
            Icon(
              FlutterRemix.arrow_right_s_line,
              color: MyPuttColors.gray[800]!,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
