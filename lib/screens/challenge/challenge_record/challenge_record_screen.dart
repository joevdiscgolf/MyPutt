import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/screens/challenge/challenge_record/components/add_set_button.dart';
import 'package:myputt/screens/challenge/challenge_record/components/challenge_record_app_bar.dart';
import 'package:myputt/screens/challenge/challenge_record/components/putts_made_container.dart';
import 'package:myputt/screens/challenge/challenge_record/screens/challenge_result_screen.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:myputt/cubits/challenges/challenges_cubit.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/utils/colors.dart';
import 'components/challenge_progress_panel.dart';
import 'components/challenge_record_set_row.dart';

class ChallengeRecordScreen extends StatefulWidget {
  const ChallengeRecordScreen({Key? key, required this.challenge})
      : super(key: key);

  static const String routeName = '/challenge_record_screen';

  final PuttingChallenge challenge;

  @override
  State<ChallengeRecordScreen> createState() => _ChallengeRecordScreenState();
}

class _ChallengeRecordScreenState extends State<ChallengeRecordScreen> {
  late ChallengesCubit _challengesCubit;
  late Stream documentStream;
  final GlobalKey<ScrollSnapListState> _puttsMadePickerKey = GlobalKey();

  int _puttsPickerFocusedIndex = 0;

  @override
  void initState() {
    _challengesCubit = BlocProvider.of<ChallengesCubit>(context);
    _puttsPickerFocusedIndex =
        BlocProvider.of<ChallengesCubit>(context).getPuttsPickerIndex();
    super.initState();
  }

  @override
  void dispose() {
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
            (MapEntry<int, PuttingSet> entry) {
              final int index = entry.key;

              return ChallengeRecordSetRow(
                setNumber: index + 1,
                currentUserPuttsMade: entry.value.puttsMade.toInt(),
                opponentPuttsMade: opponentSets.length > index
                    ? opponentSets[index].puttsMade
                    : null,
                setLength: entry.value.puttsAttempted.toInt(),
              );
            },
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
