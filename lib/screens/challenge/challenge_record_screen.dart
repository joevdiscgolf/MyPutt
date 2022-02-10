import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/previous_sets_list.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/bloc/cubits/challenges_cubit.dart';
import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/components/putts_made_picker.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/screens/challenge/components/challenge_scroll_snap_lists.dart';

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
                print('item count: $itemCount');
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
                if (state is ChallengeComplete) {
                  return PrimaryButton(
                      label: 'Finish challenge',
                      width: double.infinity,
                      height: 50,
                      icon: FlutterRemix.check_line,
                      onPressed: () {});
                }
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
                            "length: ${state.currentChallenge.recipientSets.length}");
                        challengerKey.currentState?.focusToItem(
                            state.currentChallenge.recipientSets.length + 1);
                        currentUserKey.currentState?.focusToItem(
                            state.currentChallenge.recipientSets.length + 1);
                        numberListKey.currentState?.focusToItem(
                            state.currentChallenge.recipientSets.length + 1);
                      });
                } else {
                  return const Text('Something went wrong');
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          BlocBuilder<ChallengesCubit, ChallengesState>(
            builder: (context, state) {
              if (state is ChallengeInProgress) {
                return PreviousSetsList(
                    sets: state.currentChallenge.recipientSets);
              } else if (state is ChallengeComplete) {
                print('challenge complete');
                return PreviousSetsList(
                    sets: state.currentChallenge.recipientSets);
              } else {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }
            },
          ),
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

  void dialogCallBack() {
    if (!sessionInProgress) {
      Navigator.pop(context);
    }
  }
}
