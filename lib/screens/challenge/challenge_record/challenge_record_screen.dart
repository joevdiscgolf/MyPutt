import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/screens/challenge/challenge_record/components/add_set_button.dart';
import 'package:myputt/screens/challenge/challenge_record/components/challenge_record_app_bar.dart';
import 'package:myputt/screens/challenge/challenge_record/components/putts_made_container.dart';
import 'package:myputt/screens/challenge/challenge_record/screens/challenge_result_screen.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:myputt/cubits/challenges/challenges_cubit.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/utils/colors.dart';
import 'components/challenge_progress_panel.dart';
import 'components/challenge_record_set_row.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class ChallengeRecordScreen extends StatefulWidget {
  const ChallengeRecordScreen({Key? key, required this.challenge})
      : super(key: key);

  static const String routeName = '/challenge_record_screen';

  final PuttingChallenge challenge;

  @override
  _ChallengeRecordScreenState createState() => _ChallengeRecordScreenState();
}

class _ChallengeRecordScreenState extends State<ChallengeRecordScreen> {
  late ChallengesCubit _challengesCubit;
  late Stream documentStream;
  late StreamSubscription _streamSubscription;
  final UserRepository _userRepository = locator.get<UserRepository>();
  final GlobalKey<ScrollSnapListState> _puttsMadePickerKey = GlobalKey();

  int _puttsPickerFocusedIndex = 0;

  @override
  void initState() {
    _challengesCubit = BlocProvider.of<ChallengesCubit>(context);
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser != null) {
      documentStream = firestore
          .doc(
              '$challengesCollection/${currentUser.uid}/$challengesCollection/${widget.challenge.id}')
          .snapshots();
      _streamSubscription = documentStream.listen((snapshot) {
        BlocProvider.of<ChallengesCubit>(context)
            .updateIncomingChallenge(snapshot.data());
      });
    }
    _puttsPickerFocusedIndex =
        BlocProvider.of<ChallengesCubit>(context).getPuttsPickerIndex();
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    _challengesCubit.closeChallenge();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
      builder: (context, state) {
        if (state is! CurrentChallengeState) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EmptyState(
                  onRetry: () =>
                      BlocProvider.of<ChallengesCubit>(context).reload(),
                )
              ],
            ),
          );
        }

        switch (state.challengeStage) {
          case ChallengeStage.finished:
            return ChallengeResultScreen(challenge: state.currentChallenge);
          default:
            return Scaffold(
              appBar: const ChallengeRecordAppBar(),
              backgroundColor: MyPuttColors.white,
              body: NestedScrollView(
                body: _mainBody(context, state),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                        child: ChallengeProgressPanel(state: state))
                  ];
                },
              ),
            );
        }
      },
    );
  }

  Widget _mainBody(BuildContext context, ChallengesState state) {
    if (state is! CurrentChallengeState) {
      return const SizedBox();
    }

    final List<PuttingSet> currentUserSets =
        state.currentChallenge.currentUserSets;
    final List<PuttingSet> opponentSets = state.currentChallenge.opponentSets;

    final List<Widget> setRows = List.from(
      currentUserSets
          .asMap()
          .entries
          .map(
            (entry) => ChallengeRecordSetRow(
              setNumber: entry.key + 1,
              currentUserPuttsMade: entry.value.puttsMade.toInt(),
              opponentPuttsMade: opponentSets.length >= currentUserSets.length
                  ? opponentSets[entry.key].puttsMade.toInt()
                  : null,
              setLength: entry.value.puttsAttempted.toInt(),
            ),
          )
          .toList()
          .reversed,
    );

    return ListView(
      children: [
        const SizedBox(height: 4),
        PuttsMadeContainer(
          state: state,
          updatePickerIndex: (int newIndex) =>
              setState(() => _puttsPickerFocusedIndex = newIndex),
          sslKey: _puttsMadePickerKey,
        ),
        const SizedBox(height: 4),
        AddSetButton(
          state: state,
          focusedIndex: _puttsPickerFocusedIndex,
          endChallenge: () {},
        ),
        const SizedBox(height: 12),
        ...setRows
      ],
    );
  }
}
