import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/cubits/events/events_cubit.dart';
import 'package:myputt/data/types/events/myputt_event.dart';
import 'package:myputt/screens/events/event_record/event_record_screen.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/panel_helpers.dart';

class CompeteButton extends StatelessWidget {
  const CompeteButton({
    Key? key,
    required this.event,
    required this.refreshData,
  }) : super(key: key);

  final MyPuttEvent event;
  final Function refreshData;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsCubit, EventsState>(
      builder: (context, state) {
        if (state is! ActiveEventState) {
          return Container();
        }
        final double buttonHeight =
            MediaQuery.of(context).viewPadding.bottom > 20 ? 124 : 100;
        final double bottomPadding =
            MediaQuery.of(context).viewPadding.bottom > 20 ? 24 : 0;
        final double percentComplete =
            state.event.eventCustomizationData.challengeStructure.isEmpty
                ? 0
                : state.eventPlayerData.sets.length.toDouble() /
                    state.event.eventCustomizationData.challengeStructure.length
                        .toDouble();
        final double screenWidth = MediaQuery.of(context).size.width;

        return Container(
          padding: EdgeInsets.only(bottom: bottomPadding),
          color: Colors.transparent,
          width: double.infinity,
          height: buttonHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: buttonHeight,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: MyPuttColors.gray[100]!,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Transform.translate(
                  offset: Offset(screenWidth * -((1 - percentComplete) / 2), 0),
                  child: Container(
                    height: buttonHeight,
                    width: percentComplete == 0
                        ? 0
                        : screenWidth * percentComplete,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(colors: [
                        Colors.blue.withOpacity(0.5),
                        MyPuttColors.blue.withOpacity(0.8),
                      ]),
                    ),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Icon(
                    FlutterRemix.sword_fill,
                    size: 40,
                    color: MyPuttColors.white,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Icon(
                    FlutterRemix.arrow_right_s_line,
                    size: 32,
                    color: percentComplete == 1
                        ? MyPuttColors.white
                        : MyPuttColors.darkGray,
                  ),
                ),
              ),
              Bounceable(
                onTap: () {
                  print('tapped');
                  Vibrate.feedback(FeedbackType.light);
                  BlocProvider.of<EventsCubit>(context).openEvent(event);
                  displayBottomSheet(
                    context,
                    EventRecordScreen(event: event),
                    dismissibleOnTap: true,
                    enableDrag: false,
                    onDismiss: refreshData,
                  );
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: buttonHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: _getTextSpans(context, percentComplete),
                          ),
                        ),
                      ],
                    ),
                    // title: _getTitle(percentComplete),
                    color: Colors.transparent,
                    width: screenWidth,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<TextSpan> _getTextSpans(BuildContext context, double percentComplete) {
    final TextStyle? style = Theme.of(context).textTheme.headline6?.copyWith(
          color: MyPuttColors.darkGray,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        );
    if (percentComplete == 0) {
      return [TextSpan(text: 'Get started!', style: style)];
    } else if (percentComplete < 1) {
      return [
        TextSpan(
            text: '${((percentComplete) * 100).toStringAsFixed(0)}% ',
            style: style?.copyWith(fontWeight: FontWeight.bold)),
        TextSpan(text: 'complete', style: style)
      ];
    } else {
      return [
        TextSpan(
            text: 'Finish challenge',
            style: style?.copyWith(color: MyPuttColors.white))
      ];
    }
  }
}
