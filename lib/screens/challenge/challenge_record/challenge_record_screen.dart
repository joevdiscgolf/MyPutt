import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/data/types/users/myputt_user.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/screens/challenge/challenge_record/components/undo_button.dart';
import 'package:myputt/screens/challenge/challenge_record/screens/challenge_result_screen.dart';
import 'package:myputt/services/firebase/fb_constants.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/components/misc/putts_made_picker.dart';
import 'package:myputt/data/types/sessions/putting_set.dart';
import 'package:myputt/components/dialogs/confirm_dialog.dart';
import 'package:myputt/utils/colors.dart';
import 'components/challenge_progress_panel.dart';
import 'components/challenge_record_set_row.dart';

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
  late ScrollController _scrollController;

  bool sessionInProgress = true;
  int puttsMadePickerLength = 0;
  int puttsPickerFocusedIndex = 0;
  int opponentFocusedIndex = 0;
  int currentUserFocusedIndex = 0;
  int challengeSetsCompleted = 0;

  @override
  void initState() {
    _scrollController = ScrollController();
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser != null) {
      documentStream = firestore
          .doc(
              '$challengesCollection/${currentUser.uid}/$challengesCollection/${widget.challengeId}')
          .snapshots();
      _streamSubscription = documentStream.listen((snapshot) {
        BlocProvider.of<ChallengesCubit>(context)
            .updateIncomingChallenge(snapshot.data());
      });
    }
    puttsPickerFocusedIndex =
        BlocProvider.of<ChallengesCubit>(context).getPuttsPickerIndex();
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
      builder: (context, state) {
        if (state is ChallengeFinished) {
          return ChallengeResultScreen(
            challenge: state.finishedChallenge,
          );
        }
        return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(40.0),
              child: AppBar(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                leading: IconButton(
                    onPressed: () {
                      Vibrate.feedback(FeedbackType.light);
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      FlutterRemix.arrow_left_s_line,
                      color: MyPuttColors.darkGray,
                    )),
              ),
            ),
            backgroundColor: MyPuttColors.white,
            body: NestedScrollView(
              controller: _scrollController,
              body: _mainBody(context),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: ChallengeProgressPanel(),
                  )
                ];
              },
            ));
      },
    );
  }

  Widget _mainBody(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
        builder: (context, state) {
      if (state is! ChallengesErrorState && state.currentChallenge != null) {
        final List<PuttingSet> currentUserSets =
            state.currentChallenge!.currentUserSets;
        final List<PuttingSet> opponentSets =
            state.currentChallenge!.opponentSets;
        final List<Widget> children = List.from(currentUserSets
            .asMap()
            .entries
            .map((entry) => ChallengeRecordSetRow(
                  setNumber: entry.key,
                  currentUserPuttsMade: entry.value.puttsMade.toInt(),
                  opponentPuttsMade:
                      opponentSets.length >= currentUserSets.length
                          ? opponentSets[entry.key].puttsMade.toInt()
                          : null,
                  setLength: entry.value.puttsAttempted.toInt(),
                ))
            .toList()
            .reversed);
        return ListView(
          children: [
            const SizedBox(height: 4),
            _puttsMadeContainer(context),
            const SizedBox(height: 4),
            _addSetButton(context),
            const SizedBox(height: 12),
            ...children
          ],
        );
      }
      return Container();
    });
  }

  Widget _addSetButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<ChallengesCubit, ChallengesState>(
        builder: (context, state) {
          if (state is BothUsersComplete) {
            return MyPuttButton(
                title: 'Finish Challenge',
                color: MyPuttColors.lightGreen,
                iconData: FlutterRemix.check_line,
                iconColor: Colors.white,
                width: MediaQuery.of(context).size.width / 4,
                onPressed: () {
                  Vibrate.feedback(FeedbackType.light);
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
                                  .finishChallenge();
                            },
                            buttonlabel: 'Finish',
                            title: 'Finish challenge?',
                            confirmColor: MyPuttColors.lightGreen,
                          )));
                });
          } else if (state is CurrentUserComplete &&
              state.currentChallenge != null) {
            return MyPuttButton(
              title:
                  'Waiting for ${state.currentChallenge!.opponentUser?.displayName ?? 'Unknown'}...',
              color: Colors.blue,
              width: MediaQuery.of(context).size.width / 2,
              onPressed: () {
                Vibrate.feedback(FeedbackType.light);
              },
              textColor: Colors.white,
            );
          }
          if ((state is ChallengeInProgress || state is OpponentUserComplete) &&
              state.currentChallenge != null) {
            return MyPuttButton(
                title: 'Add Set',
                color: Colors.blue,
                iconData: FlutterRemix.add_line,
                iconColor: MyPuttColors.white,
                width: 50,
                shadowColor: MyPuttColors.gray[400],
                onPressed: () {
                  Vibrate.feedback(FeedbackType.light);
                  if (state.currentChallenge!.currentUserSets.length <
                      state.currentChallenge!.challengeStructure.length) {
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
            return MyPuttButton(
              title: 'Add Set',
              color: Colors.blue,
              iconData: FlutterRemix.add_line,
              iconColor: MyPuttColors.white,
              width: 50,
              shadowColor: MyPuttColors.gray[400],
              onPressed: () {},
            );
          }
        },
      ),
    );
  }

  Widget _puttsMadeContainer(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
      builder: (context, state) {
        int length = 0;
        if (state is ChallengesErrorState) {
          return Container();
        } else if ((state is CurrentUserComplete ||
                state is BothUsersComplete) &&
            state.currentChallenge != null) {
          length = state
              .currentChallenge!
              .challengeStructure[
                  state.currentChallenge!.currentUserSets.length - 1]
              .setLength;
        } else {
          length = state
              .currentChallenge!
              .challengeStructure[
                  state.currentChallenge!.currentUserSets.length]
              .setLength;
        }
        return Container(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          decoration: const BoxDecoration(
            color: MyPuttColors.white,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Putts made',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  fontSize: 20, color: MyPuttColors.darkGray)),
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: UndoButton(),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              PuttsMadePicker(
                initialIndex: length.toDouble(),
                length: length,
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
      },
    );
  }

  void dialogCallBack() {
    if (!sessionInProgress) {
      Navigator.pop(context);
    }
  }
}
