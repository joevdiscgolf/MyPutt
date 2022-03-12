import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/misc/challenge_previous_sets_list.dart';
import 'package:myputt/data/types/users/myputt_user.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/screens/challenge/challenge_record/components/challenge_director_panel.dart';
import 'package:myputt/services/firebase/fb_constants.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/components/misc/putts_made_picker.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/components/dialogs/confirm_dialog.dart';
import 'package:myputt/theme/theme_data.dart';
import 'package:myputt/utils/calculators.dart';
import 'components/challenge_scroll_snap_lists.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class ChallengeRecordScreen extends StatefulWidget {
  const ChallengeRecordScreen({Key? key, required this.challengeId})
      : super(key: key);

  static String routeName = '/challenge_record_screen';
  final String challengeId;

  @override
  _ChallengeRecordScreenState createState() => _ChallengeRecordScreenState();
}

class _ChallengeRecordScreenState extends State<ChallengeRecordScreen> {
  late Stream documentStream;
  late StreamSubscription _streamSubscription;

  final UserRepository _userRepository = locator.get<UserRepository>();

  final GlobalKey<ScrollSnapListState> puttsMadePickerKey = GlobalKey();
  late PuttsMadePicker puttsMadePicker;

  bool sessionInProgress = true;

  int puttsMadePickerLength = 0;
  int puttsPickerFocusedIndex = 0;
  int opponentFocusedIndex = 0;
  int currentUserFocusedIndex = 0;
  int challengeSetsCompleted = 0;
  int lastUndoTime = 0;

  final GlobalKey<ScrollSnapListState> opponentKey = GlobalKey();
  final GlobalKey<ScrollSnapListState> currentUserKey = GlobalKey();
  final GlobalKey<ScrollSnapListState> numberListKey = GlobalKey();

  @override
  void initState() {
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser != null) {
      documentStream = firestore
          .doc(
              '$challengesCollection/${currentUser.uid}/$challengesCollection/${widget.challengeId}')
          .snapshots();
      _streamSubscription = documentStream.listen((snapshot) {
        BlocProvider.of<ChallengesCubit>(context)
            .updateOpponentSets(snapshot.data());
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

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
      child: ListView(
        children: [
          _challengeProgressPanel(context),
          const SizedBox(height: 10),
          Row(
            children: const [
              Expanded(child: ChallengeDirectorPanel()),
            ],
          ),
          const SizedBox(height: 10),
          BlocBuilder<ChallengesCubit, ChallengesState>(
            builder: (context, state) {
              if (state is! ChallengesErrorState) {
                return _puttsMadeContainer(context);
              } else {
                return Container();
              }
            },
          ),
          const SizedBox(height: 10),
          _addAndUndo(context),
          const SizedBox(height: 20),
          BlocBuilder<ChallengesCubit, ChallengesState>(
            builder: (context, state) {
              if (state is! ChallengesErrorState &&
                  state.currentChallenge != null) {
                return SizedBox(
                  height: 250,
                  child: ChallengePreviousSetsList(
                    deletable: false,
                    sets: state.currentChallenge!.currentUserSets,
                    deleteSet: () {},
                  ),
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

  Widget _addAndUndo(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(flex: 4, child: _addSetButton(context)),
            Flexible(flex: 1, child: _undoButton(context)),
          ],
        ));
  }

  Widget _challengeListContainer(
    BuildContext context,
    PuttingChallenge challenge,
    int opponentListItemCount,
    int currentUserListItemCount,
    int counterListItemCount,
    bool currentUserSetsComplete,
    double initialIndex,
  ) {
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    initialIndex: initialIndex,
                    sslKey: numberListKey,
                    onUpdate: (index) {
                      opponentKey.currentState?.focusToItem(index);
                      currentUserKey.currentState?.focusToItem(index);
                      numberListKey.currentState?.focusToItem(index);
                    },
                    itemCount: counterListItemCount,
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
                        challenge.opponentUser?.displayName ?? 'Unknown',
                        style: Theme.of(context).textTheme.bodyLarge,
                      )))),
                  ChallengeScrollSnapList(
                    initialIndex: initialIndex,
                    isCurrentUser: false,
                    sslKey: opponentKey,
                    onUpdate: (index) {
                      opponentKey.currentState?.focusToItem(index);
                      currentUserKey.currentState?.focusToItem(index);
                      numberListKey.currentState?.focusToItem(index);
                    },
                    challengeStructure: challenge.challengeStructure,
                    puttingSets: challenge.opponentSets,
                    maxSets: challenge.challengeStructure.length,
                    itemCount: opponentListItemCount,
                    challenge: challenge,
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
                          child: Text(
                        'You',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ))),
                  ChallengeScrollSnapList(
                    initialIndex: initialIndex,
                    isCurrentUser: true,
                    sslKey: currentUserKey,
                    onUpdate: (index) {
                      opponentKey.currentState?.focusToItem(index);
                      currentUserKey.currentState?.focusToItem(index);
                      numberListKey.currentState?.focusToItem(index);
                    },
                    challengeStructure: challenge.challengeStructure,
                    puttingSets: challenge.currentUserSets,
                    maxSets: challenge.challengeStructure.length,
                    itemCount: currentUserListItemCount,
                    challenge: challenge,
                  )
                ],
              )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 20,
            child: currentUserSetsComplete
                ? Container(height: 20)
                : Text(
                    '${challenge.challengeStructure.length - challenge.currentUserSets.length} remaining',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TweenAnimationBuilder<double>(
                curve: Curves.easeOutQuad,
                tween: Tween<double>(
                  begin: totalAttemptsFromSets(challenge.currentUserSets)
                          .toDouble() /
                      totalAttemptsFromStructure(challenge.challengeStructure)
                          .toDouble(),
                  end: (totalAttemptsFromSubset(challenge.currentUserSets,
                              challenge.currentUserSets.length)
                          .toDouble()) /
                      totalAttemptsFromStructure(challenge.challengeStructure)
                          .toDouble(),
                ),
                duration: const Duration(milliseconds: 400),
                builder: (context, value, _) => Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: LinearPercentIndicator(
                            lineHeight: 15,
                            percent: value,
                            progressColor: colorFromDecimal(value),
                            backgroundColor: Colors.grey[200],
                            barRadius: const Radius.circular(10),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Center(
                            child: Text('${(value * 100).toInt()} %'),
                          ),
                        )
                      ],
                    )),
          )
        ]));
  }

  Widget _challengeProgressPanel(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
      builder: (context, state) {
        if ((state is ChallengeInProgress || state is OpponentUserComplete) &&
            state.currentChallenge != null) {
          final PuttingChallenge challenge = state.currentChallenge!;
          final bool currentUserSetsComplete =
              challenge.currentUserSets.length ==
                  challenge.challengeStructure.length;
          final int opponentListItemCount =
              challenge.currentUserSets.length + 1;
          final int currentUserListItemCount =
              state.currentChallenge!.currentUserSets.length + 2;
          final int counterListItemCount =
              state.currentChallenge!.currentUserSets.length + 1;
          final double initialIndex =
              challenge.currentUserSets.length.toDouble();
          return _challengeListContainer(
              context,
              challenge,
              opponentListItemCount,
              currentUserListItemCount,
              counterListItemCount,
              currentUserSetsComplete,
              initialIndex);
        } else if ((state is CurrentUserComplete ||
                state is BothUsersComplete) &&
            state.currentChallenge != null) {
          final PuttingChallenge challenge = state.currentChallenge!;
          final int currentUserListItemCount = challenge.currentUserSets.length;
          final int opponentListItemCount = challenge.currentUserSets.length;
          final int counterListItemCount = challenge.currentUserSets.length;
          final double initialIndex =
              (challenge.currentUserSets.length - 1).toDouble();
          return _challengeListContainer(
              context,
              challenge,
              opponentListItemCount,
              currentUserListItemCount,
              counterListItemCount,
              true,
              initialIndex);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _addSetButton(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
      builder: (context, state) {
        if (state is CurrentUserComplete || state is BothUsersComplete) {
          return MyPuttButton(
              title: 'Finish Challenge',
              color: ThemeColors.green,
              iconData: FlutterRemix.check_line,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (dialogContext) => BlocProvider.value(
                        value: BlocProvider.of<ChallengesCubit>(context),
                        child: ConfirmDialog(
                          actionPressed: () async {
                            setState(() {
                              sessionInProgress = false;
                            });
                            await BlocProvider.of<ChallengesCubit>(context)
                                .completeCurrentChallenge();
                          },
                          buttonlabel: 'Finish',
                          title: 'Finish challenge?',
                          confirmColor: ThemeColors.green,
                        ))).then((value) => dialogCallBack());
              });
        }
        if ((state is ChallengeInProgress || state is OpponentUserComplete) &&
            state.currentChallenge != null) {
          return MyPuttButton(
              title: 'Add Set',
              color: Colors.blue,
              iconData: FlutterRemix.add_line,
              onPressed: () {
                if (state.currentChallenge!.currentUserSets.length <
                    state.currentChallenge!.challengeStructure.length) {
                  if (state.currentChallenge!.currentUserSets.length !=
                      state.currentChallenge!.challengeStructure.length - 1) {
                    _incrementScrollLists(state.currentChallenge!);
                  }
                  BlocProvider.of<ChallengesCubit>(context).addSet(PuttingSet(
                      timeStamp: DateTime.now().millisecondsSinceEpoch,
                      distance: state
                          .currentChallenge!
                          .challengeStructure[
                              state.currentChallenge!.currentUserSets.length]
                          .distance,
                      puttsAttempted: state
                          .currentChallenge!
                          .challengeStructure[
                              state.currentChallenge!.currentUserSets.length]
                          .setLength,
                      puttsMade: puttsPickerFocusedIndex));
                }
              });
        } else {
          return const Text('Something went wrong');
        }
      },
    );
  }

  Widget _undoButton(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
      builder: (context, state) {
        if (state is! ChallengesErrorState && state.currentChallenge != null) {
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
            onPressed: () async {
              if (state.currentChallenge!.currentUserSets.isNotEmpty) {
                final int indexToFocus =
                    state.currentChallenge!.currentUserSets.length - 1;
                BlocProvider.of<ChallengesCubit>(context).undo();
                _decrementScrollLists(state.currentChallenge!, indexToFocus);
              }
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

  Widget _puttsMadeContainer(BuildContext context) {
    return Container(
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          PuttsMadePicker(
            length: puttsMadePickerLength,
            challengeMode: true,
            sslKey: puttsMadePickerKey,
            onUpdate: (int newIndex) {
              setState(() {
                puttsPickerFocusedIndex = newIndex;
              });
            },
          ),
        ],
      ),
    );
  }

  void _focusAllToIndex(int index) {
    opponentKey.currentState?.focusToItem(index);
    currentUserKey.currentState?.focusToItem(index);
    numberListKey.currentState?.focusToItem(index);
  }

  void _incrementScrollLists(PuttingChallenge challenge) {
    setState(() {
      puttsMadePickerLength = challenge
          .challengeStructure[challenge.currentUserSets.length - 1].setLength;
      if (puttsPickerFocusedIndex + 1 > puttsMadePickerLength) {
        puttsMadePickerKey.currentState?.focusToItem(puttsMadePickerLength);
      }
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _focusAllToIndex(challenge.currentUserSets.length);
    });
  }

  void _decrementScrollLists(PuttingChallenge challenge, int index) {
    final int setLength = challenge.challengeStructure[index].setLength;
    if (puttsPickerFocusedIndex >= setLength) {
      puttsMadePickerKey.currentState?.focusToItem(setLength);
      puttsPickerFocusedIndex = setLength;
    }
    _focusAllToIndex(index);
  }

  void dialogCallBack() {
    if (!sessionInProgress) {
      Navigator.pop(context);
    }
  }
}
