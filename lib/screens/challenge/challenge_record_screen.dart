import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/previous_sets_list.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/components/putts_made_picker.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/screens/challenge/components/challenge_scroll_snap_lists.dart';

import '../../components/confirm_dialog.dart';
import '../../theme/theme_data.dart';
import '../../utils/calculators.dart';

class ChallengeRecordScreen extends StatefulWidget {
  const ChallengeRecordScreen({Key? key}) : super(key: key);

  static String routeName = '/challenge_record_screen';

  @override
  _ChallengeRecordScreenState createState() => _ChallengeRecordScreenState();
}

class _ChallengeRecordScreenState extends State<ChallengeRecordScreen> {
  final GlobalKey<ScrollSnapListState> puttsMadePickerKey = GlobalKey();
  late final PuttsMadePicker puttsMadePicker = PuttsMadePicker(
    challengeMode: true,
    sslKey: puttsMadePickerKey,
    onUpdate: (int newIndex) {
      setState(() {
        puttsPickerFocusedIndex = newIndex;
      });
    },
  );

  bool sessionInProgress = true;

  int puttsPickerFocusedIndex = 0;
  int challengeFocusedIndex = 0;
  int challengeSetsCompleted = 0;

  final GlobalKey<ScrollSnapListState> opponentKey = GlobalKey();
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
                  sets: state.currentChallenge.currentUserSets,
                  deleteSet: (PuttingSet set) {
                    BlocProvider.of<ChallengesCubit>(context).undo();
                  },
                );
              } else if (state is ChallengeComplete) {
                return PreviousSetsList(
                  deletable: false,
                  sets: state.currentChallenge.currentUserSets,
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
          final bool currentUserSetsComplete =
              challenge.currentUserSets.length == challenge.opponentSets.length;
          final int opponentListItemCount = currentUserSetsComplete
              ? challenge.currentUserSets.length
              : challenge.currentUserSets.length + 1;
          final int currentUserListItemCount = currentUserSetsComplete
              ? state.currentChallenge.currentUserSets.length
              : state.currentChallenge.currentUserSets.length + 2;
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
                            SizedBox(
                                width: 100,
                                child: Center(
                                    child: Text(
                                  'Set',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ))),
                            CounterScrollSnapList(
                              sslKey: numberListKey,
                              onUpdate: (index) {
                                opponentKey.currentState?.focusToItem(index);
                                currentUserKey.currentState?.focusToItem(index);
                                numberListKey.currentState?.focusToItem(index);
                              },
                              itemCount: opponentListItemCount,
                            )
                          ],
                        )),
                    Container(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        height: 60,
                        child: Row(
                          children: [
                            SizedBox(
                                width: 100,
                                child: Center(
                                    child: Center(
                                        child: Text(
                                  'Opponent',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                )))),
                            ChallengeScrollSnapList(
                                isCurrentUser: false,
                                sslKey: opponentKey,
                                onUpdate: (index) {
                                  opponentKey.currentState?.focusToItem(index);
                                  currentUserKey.currentState
                                      ?.focusToItem(index);
                                  numberListKey.currentState
                                      ?.focusToItem(index);
                                },
                                challengeDistances:
                                    challenge.challengeStructureDistances,
                                puttingSets: challenge.opponentSets,
                                maxSets: challenge.opponentSets.length,
                                itemCount: opponentListItemCount)
                          ],
                        )),
                    Container(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        height: 60,
                        child: Row(
                          children: [
                            SizedBox(
                                width: 100,
                                child: Center(
                                    child: Text(
                                  'You',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ))),
                            ChallengeScrollSnapList(
                              isCurrentUser: true,
                              sslKey: currentUserKey,
                              onUpdate: (index) {
                                opponentKey.currentState?.focusToItem(index);
                                currentUserKey.currentState?.focusToItem(index);
                                numberListKey.currentState?.focusToItem(index);
                              },
                              challengeDistances:
                                  challenge.challengeStructureDistances,
                              puttingSets: challenge.currentUserSets,
                              maxSets: challenge.opponentSets.length,
                              itemCount: currentUserListItemCount,
                            )
                          ],
                        )),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 20,
                      child: state.currentChallenge.opponentSets.length -
                                  state.currentChallenge.currentUserSets
                                      .length !=
                              0
                          ? Text(
                              '${state.currentChallenge.opponentSets.length - state.currentChallenge.currentUserSets.length} remaining',
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          : Container(height: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: TweenAnimationBuilder<double>(
                                tween: Tween<double>(
                                    begin: (state.currentChallenge
                                                    .currentUserSets.length -
                                                1)
                                            .toDouble() /
                                        state.currentChallenge.opponentSets
                                            .length
                                            .toDouble(),
                                    end: state.currentChallenge.currentUserSets
                                            .length
                                            .toDouble() /
                                        state.currentChallenge.opponentSets
                                            .length
                                            .toDouble()),
                                duration: const Duration(milliseconds: 100),
                                builder: (context, value, _) =>
                                    LinearProgressIndicator(
                                      minHeight: 10,
                                      value: value,
                                      color: colorFromDecimal(value),
                                      backgroundColor: Colors.grey[200],
                                    )),
                          ),
                          Flexible(
                              flex: 1,
                              child: Center(
                                child: Text(
                                    '${100 * state.currentChallenge.currentUserSets.length.toDouble() ~/ state.currentChallenge.opponentSets.length.toDouble()} %'),
                              ))
                        ],
                      ),
                    )
                  ]));
        } else if (state is ChallengeComplete) {
          final PuttingChallenge challenge = state.currentChallenge;
          final int itemCount =
              challenge.currentUserSets.length == challenge.opponentSets.length
                  ? challenge.currentUserSets.length
                  : challenge.currentUserSets.length + 1;
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
                            SizedBox(
                                width: 100,
                                child: Center(
                                    child: Text(
                                  'Set',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ))),
                            CounterScrollSnapList(
                              sslKey: numberListKey,
                              onUpdate: (index) {
                                opponentKey.currentState?.focusToItem(index);
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
                            SizedBox(
                                width: 100,
                                child: Center(
                                    child: Center(
                                        child: Text(
                                  'Opponent',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                )))),
                            ChallengeScrollSnapList(
                                isCurrentUser: false,
                                sslKey: opponentKey,
                                onUpdate: (index) {
                                  opponentKey.currentState?.focusToItem(index);
                                  currentUserKey.currentState
                                      ?.focusToItem(index);
                                  numberListKey.currentState
                                      ?.focusToItem(index);
                                },
                                challengeDistances:
                                    challenge.challengeStructureDistances,
                                puttingSets: challenge.opponentSets,
                                maxSets: challenge.opponentSets.length,
                                itemCount: itemCount)
                          ],
                        )),
                    Container(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        height: 60,
                        child: Row(
                          children: [
                            SizedBox(
                                width: 100,
                                child: Center(
                                    child: Text(
                                  'You',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ))),
                            ChallengeScrollSnapList(
                              isCurrentUser: true,
                              sslKey: currentUserKey,
                              onUpdate: (index) {
                                opponentKey.currentState?.focusToItem(index);
                                currentUserKey.currentState?.focusToItem(index);
                                numberListKey.currentState?.focusToItem(index);
                              },
                              challengeDistances:
                                  challenge.challengeStructureDistances,
                              puttingSets: challenge.currentUserSets,
                              maxSets: challenge.opponentSets.length,
                              itemCount: challenge.opponentSets.length ==
                                      challenge.currentUserSets.length
                                  ? itemCount
                                  : itemCount,
                            )
                          ],
                        )),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: 20,
                      child: state.currentChallenge.opponentSets.length -
                                  state.currentChallenge.currentUserSets
                                      .length !=
                              0
                          ? Text(
                              '${state.currentChallenge.opponentSets.length - state.currentChallenge.currentUserSets.length} remaining',
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          : Container(height: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Flexible(
                              flex: 5,
                              child: LinearProgressIndicator(
                                minHeight: 10,
                                value: state
                                        .currentChallenge.currentUserSets.length
                                        .toDouble() /
                                    state.currentChallenge.opponentSets.length
                                        .toDouble(),
                                color: colorFromDecimal(1),
                                backgroundColor: Colors.grey[200],
                              )),
                          Flexible(
                              flex: 1,
                              child: Center(
                                child: Text(
                                    '${100 * state.currentChallenge.currentUserSets.length.toDouble() / state.currentChallenge.opponentSets.length.toDouble()} %'),
                              ))
                        ],
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
                    primary: const Color(0xff00d162),
                    enableFeedback: true),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(FlutterRemix.check_line),
                    Text('Finish challenge'),
                  ],
                )),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (dialogContext) => BlocProvider.value(
                          value: BlocProvider.of<ChallengesCubit>(context),
                          child: ConfirmDialog(
                            actionPressed: () {
                              setState(() {
                                sessionInProgress = false;
                                BlocProvider.of<ChallengesCubit>(context)
                                    .completeCurrentChallenge();
                              });
                            },
                            buttonlabel: 'Finish',
                            title: 'Finish challenge?',
                            confirmColor: ThemeColors.green,
                          ))).then((value) => dialogCallBack());
                }),
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
                      distance: state
                          .currentChallenge
                          .opponentSets[
                              state.currentChallenge.currentUserSets.length]
                          .distance,
                      puttsAttempted: state
                          .currentChallenge
                          .opponentSets[
                              state.currentChallenge.currentUserSets.length]
                          .puttsAttempted,
                      puttsMade: puttsPickerFocusedIndex));
                  Future.delayed(const Duration(milliseconds: 50), () {
                    opponentKey.currentState?.focusToItem(
                        state.currentChallenge.currentUserSets.length);
                    currentUserKey.currentState?.focusToItem(
                        state.currentChallenge.currentUserSets.length);
                    numberListKey.currentState?.focusToItem(
                        state.currentChallenge.currentUserSets.length);
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
              opponentKey.currentState
                  ?.focusToItem(state.currentChallenge.currentUserSets.length);
              currentUserKey.currentState
                  ?.focusToItem(state.currentChallenge.currentUserSets.length);
              numberListKey.currentState
                  ?.focusToItem(state.currentChallenge.currentUserSets.length);
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
              opponentKey.currentState
                  ?.focusToItem(state.currentChallenge.currentUserSets.length);
              currentUserKey.currentState
                  ?.focusToItem(state.currentChallenge.currentUserSets.length);
              numberListKey.currentState
                  ?.focusToItem(state.currentChallenge.currentUserSets.length);
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
