import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/exit_button.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/components/screens/loading_screen.dart';
import 'package:myputt/cubits/events/events_cubit.dart';
import 'package:myputt/data/types/challenges/challenge_structure_item.dart';
import 'package:myputt/data/types/events/myputt_event.dart';
import 'package:myputt/screens/events/event_record/components/event_director.dart';
import 'package:myputt/screens/events/event_record/components/event_record_title.dart';
import 'package:myputt/screens/events/event_record/components/event_undo_button.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/set_helpers.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:myputt/screens/record/components/rows/putting_set_row.dart';
import 'package:myputt/data/types/sessions/putting_set.dart';
import 'package:myputt/components/misc/putts_made_picker.dart';

class EventRecordScreen extends StatefulWidget {
  const EventRecordScreen({Key? key, required this.event}) : super(key: key);

  final MyPuttEvent event;
  static String routeName = '/event_record_screen';

  @override
  _EventRecordScreenState createState() => _EventRecordScreenState();
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
    return BlocBuilder<EventsCubit, EventsState>(
      builder: (context, state) {
        if (state is EventsLoading) {
          return const LoadingScreen();
        } else if (state is! ActiveEventState) {
          return Center(
            child: Center(
              child: EmptyState(
                onRetry: () => BlocProvider.of<EventsCubit>(context)
                    .openEvent(widget.event),
              ),
            ),
          );
        }
        final bool setsFilled =
            state.event.eventCustomizationData.challengeStructure.length ==
                state.eventPlayerData.sets.length;
        final ChallengeStructureItem currentStructureItem =
            getCurrentChallengeStructureItem(
                state.event.eventCustomizationData.challengeStructure,
                state.eventPlayerData.sets);
        final int setLength = currentStructureItem.setLength;
        final int distance = currentStructureItem.distance;

        List<Widget> previousSetsChildren = List.from(state.eventPlayerData.sets
            .asMap()
            .entries
            .map((entry) => PuttingSetRow(
                  deletable: true,
                  set: entry.value,
                  index: entry.key,
                  delete: () {
                    BlocProvider.of<EventsCubit>(context)
                        .deleteSet(entry.value);
                  },
                ))
            .toList()
            .reversed);
        return Scaffold(
          appBar: AppBar(
            title: const EventRecordTitle(),
            backgroundColor: MyPuttColors.white,
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: ExitButton(),
              )
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
                                .headline6
                                ?.copyWith(
                                    color: MyPuttColors.darkGray, fontSize: 20),
                          ),
                        ),
                        EventUndoButton(
                          onPressed: () =>
                              BlocProvider.of<EventsCubit>(context).undoSet(),
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
                  title: setsFilled ? 'Finish event' : 'Add set',
                  width: double.infinity,
                  height: 50,
                  iconData: setsFilled ? null : FlutterRemix.add_line,
                  onPressed: () {
                    BlocProvider.of<EventsCubit>(context).addSet(
                      PuttingSet(
                        timeStamp: DateTime.now().millisecondsSinceEpoch,
                        puttsMade: _focusedIndex ?? setLength,
                        puttsAttempted: setLength,
                        distance: distance,
                      ),
                    );
                  },
                  color:
                      setsFilled ? MyPuttColors.lightGreen : MyPuttColors.blue,
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
