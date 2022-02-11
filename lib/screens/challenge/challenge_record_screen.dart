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
          _challengeListContainer(context),
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
              child: Row(
                children: [
                  Flexible(flex: 4, child: _addSetButton(context)),
                  Flexible(flex: 1, child: _undoButton(context)),
                ],
              )),
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          BlocBuilder<ChallengesCubit, ChallengesState>(
            builder: (context, state) {
              if (state is ChallengeInProgress) {
                return PreviousSetsList(
                  deletable: false,
                  sets: state.currentChallenge.recipientSets,
                  deleteSet: (PuttingSet set) {
                    BlocProvider.of<ChallengesCubit>(context).undo();
                  },
                );
              } else if (state is ChallengeComplete) {
                return PreviousSetsList(
                  deletable: false,
                  sets: state.currentChallenge.recipientSets,
                  deleteSet: (PuttingSet set) {
                    BlocProvider.of<ChallengesCubit>(context).undo();
                  },
                );
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

  Widget _challengeListContainer(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
      buildWhen: (previous, current) {
        return current is ChallengeInProgress || current is ChallengeComplete;
      },
      builder: (context, state) {
        if (state is ChallengeInProgress) {
          final PuttingChallenge challenge = state.currentChallenge;
          final int itemCount =
              challenge.recipientSets.length == challenge.challengerSets.length
                  ? challenge.recipientSets.length
                  : challenge.recipientSets.length + 1;
          return Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                challengerKey.currentState?.focusToItem(index);
                                currentUserKey.currentState?.focusToItem(index);
                                numberListKey.currentState?.focusToItem(index);
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
                                    child: Center(child: Text('Challenger')))),
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
                                maxSets: challenge.challengerSets.length,
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
                                challengerKey.currentState?.focusToItem(index);
                                currentUserKey.currentState?.focusToItem(index);
                                numberListKey.currentState?.focusToItem(index);
                              },
                              challengeDistances:
                                  challenge.challengeStructureDistances,
                              puttingSets: challenge.recipientSets,
                              maxSets: challenge.challengerSets.length,
                              itemCount: itemCount,
                            )
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 80,
                        height: 30,
                        child: state.currentChallenge.challengerSets.length -
                                    state.currentChallenge.recipientSets
                                        .length !=
                                0
                            ? Text(
                                '${state.currentChallenge.challengerSets.length - state.currentChallenge.recipientSets.length} remaining')
                            : Container(),
                      ),
                    )
                  ]));
        } else if (state is ChallengeComplete) {
          final PuttingChallenge challenge = state.currentChallenge;
          final int itemCount =
              challenge.recipientSets.length == challenge.challengerSets.length
                  ? challenge.recipientSets.length
                  : challenge.recipientSets.length + 1;
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
                            challengerKey.currentState?.focusToItem(index);
                            currentUserKey.currentState?.focusToItem(index);
                            numberListKey.currentState?.focusToItem(index);
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
                                child: Center(child: Text('Challenger')))),
                        ChallengeScrollSnapList(
                            isCurrentUser: false,
                            sslKey: challengerKey,
                            onUpdate: (index) {
                              challengerKey.currentState?.focusToItem(index);
                              currentUserKey.currentState?.focusToItem(index);
                              numberListKey.currentState?.focusToItem(index);
                            },
                            challengeDistances:
                                challenge.challengeStructureDistances,
                            puttingSets: challenge.challengerSets,
                            maxSets: challenge.challengerSets.length,
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
                            challengerKey.currentState?.focusToItem(index);
                            currentUserKey.currentState?.focusToItem(index);
                            numberListKey.currentState?.focusToItem(index);
                          },
                          challengeDistances:
                              challenge.challengeStructureDistances,
                          puttingSets: challenge.recipientSets,
                          maxSets: challenge.challengerSets.length,
                          itemCount: itemCount,
                        )
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: 80,
                    height: 30,
                    child: state.currentChallenge.challengerSets.length -
                                state.currentChallenge.recipientSets.length !=
                            0
                        ? Text(
                            '${state.currentChallenge.challengerSets.length - state.currentChallenge.recipientSets.length} remaining')
                        : Container(),
                  ),
                )
              ]));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _addSetButton(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
      builder: (context, state) {
        if (state is ChallengeComplete) {
          return SizedBox(
            height: 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48)),
                    primary: Colors.greenAccent[200],
                    enableFeedback: true),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(FlutterRemix.check_line),
                    Text('Finish challenge'),
                  ],
                )),
                onPressed: () {}),
          );
        }
        if (state is ChallengeInProgress) {
          return SizedBox(
            height: 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48)),
                    enableFeedback: true),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(FlutterRemix.add_line),
                    Text('Add set')
                  ],
                ),
                onPressed: () {
                  BlocProvider.of<ChallengesCubit>(context).addSet(PuttingSet(
                      distance: 10,
                      puttsAttempted: _setLength,
                      puttsMade: puttsPickerFocusedIndex));
                  Future.delayed(const Duration(milliseconds: 200), () {
                    challengerKey.currentState?.focusToItem(
                        state.currentChallenge.recipientSets.length);
                    currentUserKey.currentState?.focusToItem(
                        state.currentChallenge.recipientSets.length);
                    numberListKey.currentState?.focusToItem(
                        state.currentChallenge.recipientSets.length);
                  });
                }),
          );
        } else {
          return const Text('Something went wrong');
        }
      },
    );
  }

  Widget _undoButton(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
      builder: (context, state) {
        if (state is ChallengeInProgress) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(48)),
                primary: Colors.transparent,
                shadowColor: Colors.transparent),
            child: const Icon(
              FlutterRemix.arrow_go_back_line,
              color: Colors.blue,
            ),
            onPressed: () {
              BlocProvider.of<ChallengesCubit>(context).undo();
              challengerKey.currentState
                  ?.focusToItem(state.currentChallenge.recipientSets.length);
              currentUserKey.currentState
                  ?.focusToItem(state.currentChallenge.recipientSets.length);
              numberListKey.currentState
                  ?.focusToItem(state.currentChallenge.recipientSets.length);
            },
          );
        } else if (state is ChallengeComplete) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(48)),
                primary: Colors.transparent,
                shadowColor: Colors.transparent),
            child: const Icon(
              FlutterRemix.arrow_go_back_line,
              color: Colors.blue,
            ),
            onPressed: () {
              BlocProvider.of<ChallengesCubit>(context).undo();
              challengerKey.currentState
                  ?.focusToItem(state.currentChallenge.recipientSets.length);
              currentUserKey.currentState
                  ?.focusToItem(state.currentChallenge.recipientSets.length);
              numberListKey.currentState
                  ?.focusToItem(state.currentChallenge.recipientSets.length);
            },
          );
        } else {
          return PrimaryButton(
            label: 'Undo',
            onPressed: () {},
            width: 100,
            icon: FlutterRemix.arrow_go_back_line,
          );
        }
      },
    );
  }

  void dialogCallBack() {
    if (!sessionInProgress) {
      Navigator.pop(context);
    }
  }
}
