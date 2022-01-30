import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/bloc/cubits/sessions_cubit.dart';
import 'package:myputt/bloc/cubits/home_screen_cubit.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/screens/record/components/putting_set_row.dart';
import 'package:myputt/data/types/putting_set.dart';

class ChallengeRecordScreen extends StatefulWidget {
  const ChallengeRecordScreen({Key? key}) : super(key: key);

  static String routeName = '/challenge_record_screen';

  @override
  _ChallengeRecordScreenState createState() => _ChallengeRecordScreenState();
}

class _ChallengeRecordScreenState extends State<ChallengeRecordScreen> {
  bool sessionInProgress = true;

  int _focusedIndex = 0;
  int _setLength = 10;

  /*int _weatherIndex = 0;
  int _windIndex = 0;*/
  int _distancesIndex = 0;
/*
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
  ];*/
  final List<int> _distances = [10, 15, 20, 25, 30, 40, 50, 60];

  @override
  Widget build(BuildContext context) {
    final ScrollSnapList _puttPickerSnapList = ScrollSnapList(
      focusToItem: (index) {},
      itemSize: 80,
      itemCount: _setLength + 1,
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
      }, // dynamicSizeEquation: customEquation, //optional
    );
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
                            builder: (dialogContext) => BlocProvider.value(
                                value: BlocProvider.of<SessionsCubit>(context),
                                child: FinishSessionDialog(
                                    ChallengeRecordScreenState: this)))
                        .then((value) => dialogCallBack());
                  },
                  child: const Text('Finish'));
            },
          ),
        ],
        title: const Text('Challenges'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            //_detailsPanel(context),
            _challengeProgressPanel(context),
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
                  _puttsMadePicker(context),
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
                  onPressed: () {}),
            ),
            const SizedBox(height: 10),
            _previousSetsList(context),
          ],
        ),
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
                setState(() {
                  if (_setLength > 1) _setLength -= 1;
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
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
    );
  }

  Widget _puttsMadePicker(BuildContext context) {
    return Container(
        height: 80,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ScrollSnapList(
          focusToItem: (index) {},
          itemSize: 80,
          itemCount: _setLength + 1,
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
          }, // dynamicSizeEquation: customEquation, //optional
        ));
  }

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
    HapticFeedback.mediumImpact();
  }

  Widget _buildListItem(BuildContext context, int index) {
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
                          }))
                      .toList()
                      .reversed),
                ),
        );
      } else {
        return Container();
      }
    });
  }

  Widget _challengeProgressPanel(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ScrollSnapList(
          itemBuilder: _buildChallengerListItem,
          itemCount: 5,
          itemSize: 50,
          onItemFocus: (index) {
            setState(() {
              _focusedIndex = index;
            });
          }),
    );
  }

  Widget _buildChallengerListItem(BuildContext context, int index) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Text('box'),
    );
  }

  void dialogCallBack() {
    if (!sessionInProgress) {
      Navigator.pop(context);
    }
  }
}

class FinishSessionDialog extends StatefulWidget {
  const FinishSessionDialog(
      {Key? key, required this.ChallengeRecordScreenState})
      : super(key: key);

  final _ChallengeRecordScreenState ChallengeRecordScreenState;
  @override
  _FinishSessionDialogState createState() => _FinishSessionDialogState();
}

class _FinishSessionDialogState extends State<FinishSessionDialog> {
  String? _dialogErrorText;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Finish Putting Session',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 24,
              ),
              Text(_dialogErrorText ?? ''),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PrimaryButton(
                        width: 100,
                        height: 50,
                        label: 'Cancel',
                        fontSize: 18,
                        labelColor: Colors.grey[600]!,
                        backgroundColor: Colors.grey[200]!,
                        onPressed: () {
                          setState(() {
                            _dialogErrorText = '';
                          });
                          BlocProvider.of<SessionsCubit>(context)
                              .continueSession();
                          Navigator.pop(context);
                        }),
                    BlocBuilder<SessionsCubit, SessionsState>(
                      builder: (context, state) {
                        if (state is SessionInProgressState) {
                          return PrimaryButton(
                            label: 'Finish',
                            fontSize: 18,
                            width: 100,
                            height: 50,
                            backgroundColor: Colors.green,
                            onPressed: () async {
                              final List<PuttingSet>? sets =
                                  state.currentSession.sets;
                              if (sets == null || sets.isEmpty) {
                                setState(() {
                                  _dialogErrorText = 'Empty session!';
                                });
                              } else {
                                await BlocProvider.of<SessionsCubit>(context)
                                    .completeSession();
                                BlocProvider.of<HomeScreenCubit>(context)
                                    .reloadStats();
                                widget.ChallengeRecordScreenState
                                    .sessionInProgress = false;
                                Navigator.pop(context);
                              }
                            },
                          );
                        } else {
                          return PrimaryButton(
                              label: 'Finish',
                              fontSize: 18,
                              width: 100,
                              height: 50,
                              backgroundColor: Colors.green,
                              onPressed: () {
                                setState(() {
                                  _dialogErrorText = "No ongoing session";
                                });
                                return 'Finish';
                              });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
