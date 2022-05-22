import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/components/screens/loading_screen.dart';
import 'package:myputt/cubits/events/events_cubit.dart';
import 'package:myputt/data/types/events/myputt_event.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/screens/events/event_record/components/event_director.dart';
import 'package:myputt/screens/events/event_record/components/event_record_title.dart';
import 'package:myputt/utils/colors.dart';
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
  final UserRepository _userRepository = locator.get<UserRepository>();

  final GlobalKey<ScrollSnapListState> puttsMadePickerKey = GlobalKey();

  bool sessionInProgress = true;
  int _setLength = 10;
  int _focusedIndex = 10;
  late int _distance;

  @override
  void initState() {
    _distance = _userRepository
            .currentUser?.userSettings?.sessionSettings?.preferredDistance ??
        20;
    _setLength = _userRepository.currentUser?.userSettings?.sessionSettings
            ?.preferredPuttsPickerLength ??
        10;
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
                          .openEvent(widget.event))));
        }

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
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewPadding.bottom > 0 ? 48 : 12,
          ),
          child: ListView(
            children: [
              const EventRecordTitle(),
              const EventDirector(),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 4, top: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Putts made',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  color: MyPuttColors.darkGray, fontSize: 20)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  PuttsMadePicker(
                      length: _setLength,
                      initialIndex: _setLength.toDouble(),
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
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 4),
                child: MyPuttButton(
                  title: 'Add set',
                  width: MediaQuery.of(context).size.width / 2,
                  height: 50,
                  iconData: FlutterRemix.add_line,
                  onPressed: () {
                    BlocProvider.of<EventsCubit>(context).addSet(PuttingSet(
                        timeStamp: DateTime.now().millisecondsSinceEpoch,
                        puttsMade: _focusedIndex,
                        puttsAttempted: _setLength,
                        distance: _distance));
                  },
                ),
              ),
              const SizedBox(height: 16),
              ...previousSetsChildren,
            ],
          ),
        );
      },
    );
  }

  Widget _putterCountPicker(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              child: Text(
                '-',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 32, color: MyPuttColors.darkGray),
              ),
              onPressed: () {
                puttsMadePickerKey.currentState?.focusToItem(_setLength - 2);
                if (_setLength > 1) {
                  setState(() {
                    _setLength -= 1;
                    _focusedIndex = _setLength;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.transparent, shadowColor: Colors.transparent),
            ),
            const SizedBox(width: 5),
            Text(
              _setLength.toString(),
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontSize: 16, color: MyPuttColors.darkGray),
            ),
            const SizedBox(width: 5),
            ElevatedButton(
              child: Text(
                '+',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 32, color: MyPuttColors.darkGray),
              ),
              onPressed: () {
                setState(() {
                  _setLength += 1;
                });
                setState(() {
                  _focusedIndex = _setLength + 1;
                });
                Future.delayed(const Duration(milliseconds: 25), () {
                  puttsMadePickerKey.currentState?.focusToItem(_setLength + 1);
                });
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.transparent, shadowColor: Colors.transparent),
            ),
          ],
        ),
      ],
    );
  }

  void dialogCallBack() {
    if (!sessionInProgress) {
      Navigator.pop(context);
    }
  }
}
