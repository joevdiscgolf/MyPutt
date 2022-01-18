import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/screens/record_putting/cubits/sessions_screen_cubit.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/screens/record_putting/components/putting_set_row.dart';
import 'package:myputt/screens/record_putting/components/dialogs/finish_session_dialog.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/locator.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  static String routeName = '/record_screen';

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final SessionRepository _sessionRepository = locator.get<SessionRepository>();
  final PuttingSession? _session =
      locator.get<SessionRepository>().currentSession;

  int _focusedIndex = 0;
  int _setLength = 10;
  int? _distance;

  int _weatherIndex = 0;
  int _windIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                _conditionsPanel(context),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Putts made',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 40),
                    Column(
                      children: [
                        const Text('Putters',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            ElevatedButton(
                              child: const Text('-',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              onPressed: () {
                                setState(() {
                                  _setLength -= 1;
                                });
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              onPressed: () {
                                setState(() {
                                  _setLength += 1;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                _puttsMadePicker(context),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PrimaryButton(
                        label: 'Finish set',
                        width: double.infinity,
                        height: 50,
                        icon: FlutterRemix.arrow_right_line,
                        onPressed: () {
                          setState(() {
                            _session?.sets.add(PuttingSet(
                                puttsMade: _focusedIndex,
                                puttsAttempted: _setLength,
                                distance: _distance ?? 10));
                          });
                        }),
                    _previousSetsList(context),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      label: 'Finish Session',
                      width: double.infinity,
                      height: 50,
                      onPressed: () {
                        showDialog(
                                context: context,
                                builder: (dialogContext) => BlocProvider.value(
                                    value: BlocProvider.of<SessionsScreenCubit>(
                                        context),
                                    child: const FinishSessionDialog()))
                            .then((value) => dialogCallBack());
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _conditionsPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _puttsMadePicker(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.all(20),
      child: ScrollSnapList(
        itemSize: 80,
        itemCount: _setLength + 3,
        duration: 125,
        focusOnItemTap: true,
        onItemFocus: _onItemFocus,
        itemBuilder: _buildListItem,
        dynamicItemSize: true,
        allowAnotherDirection: true,
        dynamicSizeEquation: (displacement) {
          const threshold = 0;
          const maxDisplacement = 800;
          if (displacement >= threshold) {
            const slope = 1 / (-maxDisplacement);
            return slope * displacement + (1 - slope * threshold);
          } else {
            const slope = 1 / (maxDisplacement);
            return slope * displacement + (1 - slope * threshold);
          }
        },
        // dynamicSizeEquation: customEquation, //optional
      ),
    );
  }

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
    HapticFeedback.heavyImpact();
  }

  Widget _buildListItem(BuildContext context, int index) {
    if (index >= _setLength + 1) {
      return Container();
    }
    Color? iconColor;
    Color backgroundColor;
    if (index == 0) {
      iconColor = _focusedIndex == index ? Colors.red : Colors.grey[400]!;
      backgroundColor = Colors.transparent;
    } else {
      backgroundColor =
          index <= _focusedIndex ? const Color(0xff00d162) : Colors.grey[200]!;
    }
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.grey[600]!)),
      width: 80,
      child: Center(
          child: index == 0
              ? Icon(
                  FlutterRemix.close_circle_line,
                  color: iconColor ?? Colors.white,
                  size: 40,
                )
              : Text((index).toString(),
                  style: TextStyle(
                      color:
                          index <= _focusedIndex ? Colors.white : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold))),
    );
  }

  Widget _previousSetsList(BuildContext context) {
    return Column(
      children:
          _session?.sets.map((set) => PuttingSetRow(set: set)).toList() ?? [],
    );
  }

  void dialogCallBack() {
    _sessionRepository.ongoingSession = false;
    if (_session != null) {
      locator.get<SessionRepository>().addCompletedSession(_session!);
      BlocProvider.of<SessionsScreenCubit>(context).completeSession();
      Navigator.pop(context);
    }
  }
}
