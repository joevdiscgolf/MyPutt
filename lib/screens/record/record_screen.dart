import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/components/misc/putting_set_row.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/components/misc/putts_made_picker.dart';
import 'components/finish_session_dialog.dart';

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
  int _lastChangedPutterCount = 0;

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
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text('Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: [
                  const Text('Wind',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  PrimaryButton(
                    height: 40,
                    width: 80,
                    label: _windConditionWords[_windIndex],
                    fontSize: 12,
                    onPressed: () {
                      setState(() {
                        if (_windIndex == 3) {
                          _windIndex = 0;
                        } else {
                          _windIndex += 1;
                        }
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('Weather',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  PrimaryButton(
                    height: 40,
                    width: 80,
                    label: _weatherConditionWords[_weatherIndex],
                    fontSize: 12,
                    onPressed: () {
                      setState(() {
                        if (_weatherIndex == 2) {
                          _weatherIndex = 0;
                        } else {
                          _weatherIndex += 1;
                        }
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('Distance',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  PrimaryButton(
                    height: 40,
                    width: 80,
                    label: _distances[_distancesIndex].toString() + ' ft',
                    fontSize: 12,
                    onPressed: () {
                      setState(() {
                        if (_distancesIndex == 7) {
                          _distancesIndex = 0;
                        } else {
                          _distancesIndex += 1;
                        }
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _putterCountPicker(BuildContext context) {
    return Column(
      children: [
        const Text('Putters', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            ElevatedButton(
              child: const Text('-',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                puttsMadePickerKey.currentState?.focusToItem(_setLength - 2);
                if (_setLength > 1) {
                  setState(() {
                    _lastChangedPutterCount =
                        DateTime.now().millisecondsSinceEpoch;
                    _setLength -= 1;
                    _focusedIndex = _setLength;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
              ),
            ),
            const SizedBox(width: 5),
            Text(_setLength.toString()),
            const SizedBox(width: 5),
            ElevatedButton(
              child: const Text('+',
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
                shape: const CircleBorder(),
              ),
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
