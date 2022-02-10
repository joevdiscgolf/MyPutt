import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/bloc/cubits/sessions_cubit.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/screens/record/components/putting_set_row.dart';
import 'package:myputt/bloc/cubits/challenges_cubit.dart';
import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/components/putts_made_picker.dart';

import '../../data/types/putting_set.dart';

class ChallengeRecordScreen extends StatefulWidget {
  const ChallengeRecordScreen({Key? key}) : super(key: key);

  static String routeName = '/challenge_record_screen';

  @override
  _ChallengeRecordScreenState createState() => _ChallengeRecordScreenState();
}

class _ChallengeRecordScreenState extends State<ChallengeRecordScreen> {
  final GlobalKey<ScrollSnapListState> puttsMadePickerKey = GlobalKey();
  late final PuttsMadePicker puttsMadePicker = PuttsMadePicker(
    sslKey: puttsMadePickerKey,
    onUpdate: (int newIndex) {
      setState(() {
        puttsPickerFocusedIndex = newIndex;
      });
    },
  );

  bool sessionInProgress = true;
  final int _setLength = 10;

  int puttsPickerFocusedIndex = 0;
  int challengeFocusedIndex = 0;
  int challengeSetsCompleted = 0;

  final GlobalKey<_ChallengeRecordScreenState> challengeRecordScreenKey =
      GlobalKey();
  final GlobalKey<ScrollSnapListState> challengerKey = GlobalKey();
  final GlobalKey<ScrollSnapListState> currentUserKey = GlobalKey();
  final GlobalKey<ScrollSnapListState> numberListKey = GlobalKey();
  final GlobalKey<_CounterScrollSnapListState> counterListKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100]!,
        appBar: AppBar(
          title: const Text('Challenges'),
        ),
        body: _mainBody(context));
  }

  Widget _mainBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          BlocBuilder<ChallengesCubit, ChallengesState>(
            buildWhen: (previous, current) {
              return current is ChallengeInProgress;
            },
            builder: (context, state) {
              if (state is ChallengeInProgress) {
                final PuttingChallenge challenge = state.currentChallenge;
                final int itemCount = challenge.recipientSets.length ==
                        challenge.challengerSets.length
                    ? challenge.recipientSets.length
                    : challenge.recipientSets.length + 1;
                print(itemCount);
                return Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                          height: 30,
                          child: Row(
                            children: [
                              const SizedBox(
                                  width: 80, child: Center(child: Text('Set'))),
                              CounterScrollSnapList(
                                key: counterListKey,
                                sslKey: numberListKey,
                                onUpdate: (index) {
                                  challengerKey.currentState
                                      ?.focusToItem(index);
                                  currentUserKey.currentState
                                      ?.focusToItem(index);
                                  numberListKey.currentState
                                      ?.focusToItem(index);
                                },
                                itemCount: itemCount,
                              )
                            ],
                          )),
                      Container(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                          height: 60,
                          child: Row(
                            children: [
                              const SizedBox(
                                  width: 80,
                                  child: Center(
                                      child:
                                          Center(child: Text('Challenger')))),
                              ChallengeScrollSnapList(
                                  isCurrentUser: false,
                                  sslKey: challengerKey,
                                  onUpdate: (index) {
                                    challengerKey.currentState
                                        ?.focusToItem(index);
                                    currentUserKey.currentState
                                        ?.focusToItem(index);
                                    numberListKey.currentState
                                        ?.focusToItem(index);
                                  },
                                  challengeDistances:
                                      challenge.challengeStructureDistances,
                                  puttingSets: challenge.challengerSets,
                                  itemCount: itemCount)
                            ],
                          )),
                      Container(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                          height: 60,
                          child: Row(
                            children: [
                              const SizedBox(
                                  width: 80, child: Center(child: Text('You'))),
                              ChallengeScrollSnapList(
                                isCurrentUser: true,
                                sslKey: currentUserKey,
                                onUpdate: (index) {
                                  challengerKey.currentState
                                      ?.focusToItem(index);
                                  currentUserKey.currentState
                                      ?.focusToItem(index);
                                  numberListKey.currentState
                                      ?.focusToItem(index);
                                },
                                challengeDistances:
                                    challenge.challengeStructureDistances,
                                puttingSets: challenge.recipientSets,
                                itemCount: itemCount,
                              )
                            ],
                          )),
                    ]));
              } else {
                return Container();
              }
            },
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('Putts made',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      /*Align(
                        alignment: Alignment.centerRight,
                        child: _putterCountPicker(context),
                      ),*/
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                puttsMadePicker,
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: BlocBuilder<ChallengesCubit, ChallengesState>(
              builder: (context, state) {
                if (state is ChallengeInProgress) {
                  return PrimaryButton(
                      label: 'Add set',
                      width: double.infinity,
                      height: 50,
                      icon: FlutterRemix.add_line,
                      onPressed: () {
                        BlocProvider.of<ChallengesCubit>(context).addSet(
                            PuttingSet(
                                distance: 10,
                                puttsAttempted: _setLength,
                                puttsMade: puttsPickerFocusedIndex));
                        print(
                            'length: ${state.currentChallenge.recipientSets.length}');
                        challengerKey.currentState?.focusToItem(
                            state.currentChallenge.recipientSets.length - 1);
                        currentUserKey.currentState?.focusToItem(
                            state.currentChallenge.recipientSets.length - 1);
                        numberListKey.currentState?.focusToItem(
                            state.currentChallenge.recipientSets.length - 1);
                      });
                }
                return PrimaryButton(
                    label: 'Finish challenge',
                    width: double.infinity,
                    height: 50,
                    icon: FlutterRemix.add_line,
                    onPressed: () {});
              },
            ),
          ),
          const SizedBox(height: 10),
          _previousSetsList(context),
        ],
      ),
    );
  }

/*
  Widget _puttsMadePicker(BuildContext context) {
    return Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ScrollSnapList(
          updateOnScroll: true,
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
      _focusedPuttPickerIndex = index;
    });
    HapticFeedback.mediumImpact();
  }

  Widget _buildListItem(BuildContext context, int index) {
    Color? iconColor;
    Color backgroundColor;
    if (index == 0) {
      iconColor =
          _focusedPuttPickerIndex == index ? Colors.red : Colors.grey[400]!;
      backgroundColor = Colors.transparent;
    } else {
      backgroundColor = index <= _focusedPuttPickerIndex
          ? const Color(0xff00d162)
          : Colors.grey[200]!;
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
                      color: index <= _focusedPuttPickerIndex
                          ? Colors.white
                          : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold))),
    );
  }*/

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

  void dialogCallBack() {
    if (!sessionInProgress) {
      Navigator.pop(context);
    }
  }
}

class ChallengeScrollSnapList extends StatefulWidget {
  const ChallengeScrollSnapList(
      {Key? key,
      required this.sslKey,
      required this.onUpdate,
      required this.isCurrentUser,
      required this.itemCount,
      required this.challengeDistances,
      required this.puttingSets})
      : super(key: key);

  final GlobalKey<ScrollSnapListState> sslKey;
  final Function onUpdate;
  final bool isCurrentUser;
  final int itemCount;

  final List<int> challengeDistances;
  final List<PuttingSet> puttingSets;

  @override
  _ChallengeScrollSnapListState createState() =>
      _ChallengeScrollSnapListState();
}

class _ChallengeScrollSnapListState extends State<ChallengeScrollSnapList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ScrollSnapList(
      curve: Curves.easeOutBack,
      key: widget.sslKey,
      updateOnScroll: false,
      focusToItem: (index) {},
      itemSize: 60,
      itemCount: widget.itemCount,
      duration: 400,
      focusOnItemTap: true,
      onItemFocus: (index) {
        widget.onUpdate(index);
      },
      itemBuilder: _buildChallengeScrollListItem,
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
    ));
  }

  Widget _buildChallengeScrollListItem(BuildContext context, int index) {
    if (widget.isCurrentUser) {
      if (index == widget.puttingSets.length) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.blue[200],
              border: Border.all(color: Colors.grey[600]!)),
          width: 60,
          height: 40,
        );
      }
    }
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          border: Border.all(color: Colors.grey[600]!)),
      width: 60,
      height: 40,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('10 feet'),
            //Text('${widget.puttingSets[index].distance} ft'),
            Text('8/10'),
            //Text('${widget.puttingSets[index].puttsMade} / ${widget.puttingSets[index].puttsAttempted}'),
          ],
        ),
      ),
    );
  }
}

class CounterScrollSnapList extends StatefulWidget {
  const CounterScrollSnapList(
      {Key? key,
      required this.sslKey,
      required this.onUpdate,
      required this.itemCount})
      : super(key: key);

  final GlobalKey<ScrollSnapListState> sslKey;
  final Function onUpdate;
  final int itemCount;

  @override
  _CounterScrollSnapListState createState() => _CounterScrollSnapListState();
}

class _CounterScrollSnapListState extends State<CounterScrollSnapList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ScrollSnapList(
      curve: Curves.easeOutBack,
      key: widget.sslKey,
      updateOnScroll: false,
      focusToItem: (index) {},
      itemSize: 60,
      itemCount: widget.itemCount,
      duration: 400,
      focusOnItemTap: true,
      onItemFocus: (index) {
        widget.onUpdate(index);
      },
      itemBuilder: _buildItem,
      allowAnotherDirection: true,
      dynamicItemSize: true,
      dynamicSizeEquation: (displacement) {
        const threshold = 0;
        const maxDisplacement = 300;
        if (displacement >= threshold) {
          const slope = 1 / (-maxDisplacement);
          return slope * displacement + (1 - slope * threshold);
        } else {
          const slope = 1 / (maxDisplacement);
          return slope * displacement + (1 - slope * threshold);
        }
      },
    ));
  }

  Widget _buildItem(BuildContext context, int index) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      width: 60,
      height: 40,
      child: FittedBox(
        child: Center(
          child: Center(
              child: Text(
            (index + 1).toString(),
          )),
        ),
      ),
    );
  }
}
