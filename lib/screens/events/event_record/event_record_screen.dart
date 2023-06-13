import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/buttons/exit_button.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/components/screens/loading_screen.dart';
import 'package:myputt/cubits/events/event_detail_cubit.dart';
import 'package:myputt/models/data/challenges/challenge_structure_item.dart';
import 'package:myputt/models/data/events/event_enums.dart';
import 'package:myputt/models/data/events/myputt_event.dart';
import 'package:myputt/screens/events/event_record/components/event_director.dart';
import 'package:myputt/screens/events/event_record/components/event_record_title.dart';
import 'package:myputt/screens/events/event_record/components/event_undo_button.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/set_helpers.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:myputt/screens/record/components/rows/putting_set_row.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/components/misc/putts_made_picker.dart';

class EventRecordScreen extends StatefulWidget {
  const EventRecordScreen({Key? key, required this.event}) : super(key: key);

  final MyPuttEvent event;
  static String routeName = '/event_record_screen';

  @override
  State<EventRecordScreen> createState() => _EventRecordScreenState();
}

class _EventRecordScreenState extends State<EventRecordScreen> {
  final GlobalKey<ScrollSnapListState> puttsMadePickerKey = GlobalKey();

  bool sessionInProgress = true;
  int? _focusedIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventDetailCubit, EventDetailState>(
      builder: (context, state) {
        if (state is EventDetailLoading) {
          return const LoadingScreen();
        } else if (state is! EventDetailLoaded) {
          return Center(
            child: Center(
              child: EmptyState(
                onRetry: () => BlocProvider.of<EventDetailCubit>(context)
                    .openEvent(widget.event),
              ),
            ),
          );
        }
        final bool setsFilled =
            state.event.eventCustomizationData.challengeStructure.length ==
                state.currentPlayerData.sets.length;
        final ChallengeStructureItem currentStructureItem =
            SetHelpers.getCurrentChallengeStructureItem(
                state.event.eventCustomizationData.challengeStructure,
                state.currentPlayerData.sets);
        final int setLength = currentStructureItem.setLength;
        final int distance = currentStructureItem.distance;

        List<Widget> previousSetsChildren = List.from(
          state.currentPlayerData.sets
              .asMap()
              .entries
              .map((entry) => PuttingSetRow(
                    deletable: true,
                    set: entry.value,
                    index: entry.key,
                    delete: () {
                      BlocProvider.of<EventDetailCubit>(context)
                          .deleteSet(entry.value);
                    },
                  ))
              .toList()
              .reversed,
        );
        return Scaffold(
          appBar: AppBar(
            title: const EventRecordTitle(),
            backgroundColor: MyPuttColors.white,
            actions: const [
              Padding(padding: EdgeInsets.only(right: 16), child: ExitButton())
            ],
          ),
          body: Column(
            children: [
              const EventDirector(),
              const SizedBox(height: 16),
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Putts made',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    color: MyPuttColors.darkGray, fontSize: 20),
                          ),
                        ),
                        EventUndoButton(
                          onPressed: () {
                            BlocProvider.of<EventDetailCubit>(context)
                                .undoSet();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  PuttsMadePicker(
                      length: setLength,
                      initialIndex: setLength.toDouble(),
                      challengeMode: false,
                      sslKey: puttsMadePickerKey,
                      onUpdate: (int newIndex) {
                        setState(() {
                          _focusedIndex = newIndex;
                        });
                      }),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: MyPuttButton(
                  disabled: setsFilled,
                  title: 'Add set',
                  width: double.infinity,
                  height: 50,
                  iconData: setsFilled ? null : FlutterRemix.add_line,
                  onPressed: () {
                    if (state.event.status == EventStatus.complete) {
                      Vibrate.feedback(FeedbackType.warning);
                      return;
                    }
                    BlocProvider.of<EventDetailCubit>(context).addSet(
                      PuttingSet(
                        timeStamp: DateTime.now().millisecondsSinceEpoch,
                        puttsMade: _focusedIndex ?? setLength,
                        puttsAttempted: setLength,
                        distance: distance,
                      ),
                    );
                  },
                  backgroundColor: MyPuttColors.blue,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: ListView(children: previousSetsChildren)),
            ],
          ),
        );
      },
    );
  }

  void dialogCallBack() {
    if (!sessionInProgress) {
      Navigator.pop(context);
    }
  }
}
