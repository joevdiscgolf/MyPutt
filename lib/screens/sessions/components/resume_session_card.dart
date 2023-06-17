import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/cubits/record/record_cubit.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/screens/record/record_screen.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/layout_helpers.dart';

class ResumeSessionCard extends StatelessWidget implements PreferredSizeWidget {
  const ResumeSessionCard({Key? key, required this.currentSession})
      : super(key: key);

  final PuttingSession currentSession;

  @override
  get preferredSize => const Size.fromHeight(190);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyPuttColors.white,
      child: Bounceable(
        onTap: () {
          Vibrate.feedback(FeedbackType.light);
          BlocProvider.of<RecordCubit>(context).openSession(currentSession);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const RecordScreen();
              },
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: 24,
            right: 24,
            bottom: 8,
          ),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: standardBoxShadow(),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: const AssetImage(
                      'assets/images/winthrop_hole_6_putt.JPG',
                    ),
                    colorFilter: ColorFilter.mode(
                      MyPuttColors.gray[700]!.withOpacity(0.85),
                      BlendMode.srcOver,
                    ),
                  ),
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Resume session',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: MyPuttColors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${currentSession.sets.length} sets, ${totalAttemptsFromSets(currentSession.sets)} putts',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: MyPuttColors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16, right: 16),
                        child: Icon(
                          FlutterRemix.arrow_right_s_line,
                          color: MyPuttColors.white,
                        ),
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
        ),
      ),
    );
  }
}
