import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/utils/colors.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/components/misc/putting_set_row.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/components/misc/putts_made_picker.dart';
import 'components/finish_session_dialog.dart';
import 'components/rows/conditions_row.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  static String routeName = '/record_screen';

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final GlobalKey<ScrollSnapListState> puttsMadePickerKey = GlobalKey();

  bool sessionInProgress = true;
  int _setLength = 10;
  int _focusedIndex = 10;
  int _weatherIndex = 0;
  int _windIndex = 0;
  int _distancesIndex = 0;

  final List<String> _windConditionWords = [
    'Calm',
    'Breezy',
    'Strong',
    'Intense',
  ];
  final List<String> _weatherConditionWords = [
    'Sunny',
    'Rainy',
    'Snowy',
  ];
  final List<int> _distances = [10, 15, 20, 25, 30, 40, 50, 60];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100]!,
      appBar: AppBar(
        actions: [
          BlocBuilder<SessionsCubit, SessionsState>(
            builder: (context, state) {
              return ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(shadowColor: Colors.transparent),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (dialogContext) =>
                            FinishSessionDialog(stopSession: () {
                              setState(() {
                                sessionInProgress = false;
                              });
                            })).then((value) => dialogCallBack());
                  },
                  child: const Text('Finish'));
            },
          ),
        ],
        title: const Text('Record'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _detailsPanel(context),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text('Putts made',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _putterCountPicker(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
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
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: PrimaryButton(
                  label: 'Add set',
                  width: double.infinity,
                  height: 50,
                  icon: FlutterRemix.add_line,
                  onPressed: () {
                    BlocProvider.of<SessionsCubit>(context).addSet(PuttingSet(
                        timeStamp: DateTime.now().millisecondsSinceEpoch,
                        puttsMade: _focusedIndex,
                        puttsAttempted: _setLength,
                        distance: _distances[_distancesIndex]));
                  }),
            ),
            const SizedBox(height: 10),
            _previousSetsList(context),
          ],
        ),
      ),
    );
  }

  Widget _detailsPanel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 32,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Details',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontSize: 20, color: MyPuttColors.gray[800]!),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        ConditionsRow(
          onPressed: () {},
          iconData: FlutterRemix.windy_line,
          label: 'Wind',
        ),
        ConditionsRow(
          onPressed: () {},
          iconData: FlutterRemix.sun_fill,
          label: 'Weather',
        ),
        ConditionsRow(
          onPressed: () {},
          iconData: FlutterRemix.map_pin_2_line,
          label: 'Distance',
        ),
      ],
    );
  }

  Widget _putterCountPicker(BuildContext context) {
    return Column(
      children: [
        const Text('Putters', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            ElevatedButton(
              child: Text(
                '-',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 24, color: MyPuttColors.gray[800]),
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
                  ?.copyWith(fontSize: 16, color: MyPuttColors.gray[800]),
            ),
            const SizedBox(width: 5),
            ElevatedButton(
              child: Text(
                '+',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 24, color: MyPuttColors.gray[800]),
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

  Widget _previousSetsList(BuildContext context) {
    return BlocBuilder<SessionsCubit, SessionsState>(builder: (context, state) {
      if (state is SessionInProgressState) {
        return Flexible(
          fit: FlexFit.loose,
          child: state.currentSession.sets.isEmpty
              ? const Center(child: Text('No sets yet'))
              : ListView(
                  children: List.from(state.currentSession.sets
                      .asMap()
                      .entries
                      .map((entry) => PuttingSetRow(
                            deletable: true,
                            set: entry.value,
                            index: entry.key,
                            delete: () {
                              BlocProvider.of<SessionsCubit>(context)
                                  .deleteSet(entry.value);
                            },
                          ))
                      .toList()
                      .reversed),
                ),
        );
      } else {
        return Container();
      }
    });
  }

  void dialogCallBack() {
    if (!sessionInProgress) {
      Navigator.pop(context);
    }
  }
}
