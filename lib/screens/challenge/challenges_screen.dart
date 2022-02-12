import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/screens/challenge/challenge_record_screen.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'components/pending_challenge_item.dart';

enum ChallengeCategory { active, pending, complete, none }

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({Key? key}) : super(key: key);

  static String routeName = '/challenges_screen';

  @override
  _ChallengesState createState() => _ChallengesState();
}

class _ChallengesState extends State<ChallengesScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ChallengesCubit>(context).reload();
    /*return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return Scaffold(
              backgroundColor: Colors.grey[100]!,
              appBar: AppBar(
                title: const Text('Challenges'),
                centerTitle: true,
              ),
              body: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    BlocBuilder<ChallengesCubit, ChallengesState>(
                      builder: (context, state) {
                        if (state is ChallengeInProgress) {
                          final challengeCount =
                              state.completedChallenges.length +
                                  state.pendingChallenges.length +
                                  state.activeChallenges.length;
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                  '$challengeCount Challenge${challengeCount == 1 ? '' : 's'}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          );
                        } else if (state is NoCurrentChallenge) {
                          final challengeCount =
                              state.completedChallenges.length +
                                  state.pendingChallenges.length +
                                  state.activeChallenges.length;
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                  '$challengeCount Challenge${challengeCount == 1 ? '' : 's'}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    /*PrimaryButton(
                      label: 'Open challenge',
                      onPressed: () {
                        BlocProvider.of<ChallengesCubit>(context)
                            .openChallenge();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                BlocProvider.value(
                                    value: BlocProvider.of<ChallengesCubit>(
                                        context),
                                    child: const ChallengeRecordScreen())));
                      },
                      width: double.infinity,
                    ),*/
                    const SizedBox(height: 10),
                    Expanded(child: ChallengesLists()),
                  ],
                ),
              ),
            );
          },
        );
      },
    );*/
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: Colors.grey[100]!,
          appBar: AppBar(
            title: const Text('Challenges'),
            centerTitle: true,
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: BlocBuilder<ChallengesCubit, ChallengesState>(
                  builder: (context, state) {
                    if (state is ChallengeInProgress) {
                      return TabBar(
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            25.0,
                          ),
                          color: Colors.blue,
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black,
                        tabs: [
                          Tab(
                              child: Stack(children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Active'),
                                  const Icon(
                                    FlutterRemix.play_mini_line,
                                    size: 15,
                                  ),
                                  Visibility(
                                      visible:
                                          state.activeChallenges.isNotEmpty,
                                      child: Container(
                                        width: 15,
                                        height: 15,
                                        child: Center(
                                          child: Text(
                                              state.activeChallenges.length
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.black)),
                                        ),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                      ))
                                ],
                              ),
                            ),
                          ])),
                          Tab(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Pending'),
                              const SizedBox(width: 2),
                              const Icon(
                                FlutterRemix.repeat_line,
                                size: 15,
                              ),
                              Visibility(
                                  visible: state.pendingChallenges.isNotEmpty,
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    child: Center(
                                      child: Text(
                                          state.pendingChallenges.length
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.black)),
                                    ),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                  ))
                            ],
                          )),
                          Tab(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Complete'),
                              const Icon(
                                FlutterRemix.check_line,
                                size: 15,
                              ),
                              Visibility(
                                  visible: state.completedChallenges.isNotEmpty,
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    child: Center(
                                      child: Text(
                                          state.completedChallenges.length
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.black)),
                                    ),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                  ))
                            ],
                          ))
                        ],
                      );
                    } else if (state is NoCurrentChallenge) {
                      return TabBar(
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            25.0,
                          ),
                          color: Colors.blue,
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black,
                        tabs: [
                          Tab(
                              child: Stack(children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Active'),
                                  const Icon(
                                    FlutterRemix.play_mini_line,
                                    size: 15,
                                  ),
                                  Visibility(
                                      visible:
                                          state.activeChallenges.isNotEmpty,
                                      child: Container(
                                        width: 15,
                                        height: 15,
                                        child: Center(
                                          child: Text(
                                              state.activeChallenges.length
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.black)),
                                        ),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                      ))
                                ],
                              ),
                            ),
                          ])),
                          Tab(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Pending'),
                              const SizedBox(width: 2),
                              const Icon(
                                FlutterRemix.repeat_line,
                                size: 15,
                              ),
                              Visibility(
                                  visible: state.pendingChallenges.isNotEmpty,
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    child: Center(
                                      child: Text(
                                          state.pendingChallenges.length
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.black)),
                                    ),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                  ))
                            ],
                          )),
                          Tab(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Complete'),
                              const Icon(
                                FlutterRemix.check_line,
                                size: 15,
                              ),
                              Visibility(
                                  visible: state.completedChallenges.isNotEmpty,
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    child: Center(
                                      child: Text(
                                          state.completedChallenges.length
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.black)),
                                    ),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                  ))
                            ],
                          ))
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<ChallengesCubit, ChallengesState>(
                  builder: (context, state) {
                    if (state is ChallengeInProgress) {
                      return TabBarView(children: [
                        ChallengesList(
                            category: ChallengeCategory.active,
                            challenges: state.activeChallenges),
                        ChallengesList(
                            category: ChallengeCategory.pending,
                            challenges: state.pendingChallenges),
                        ChallengesList(
                            category: ChallengeCategory.pending,
                            challenges: state.completedChallenges),
                      ]);
                    } else if (state is NoCurrentChallenge) {
                      return TabBarView(children: [
                        ChallengesList(
                            category: ChallengeCategory.active,
                            challenges: state.activeChallenges),
                        ChallengesList(
                            category: ChallengeCategory.pending,
                            challenges: state.pendingChallenges),
                        ChallengesList(
                            category: ChallengeCategory.pending,
                            challenges: state.completedChallenges),
                      ]);
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }
}
/*
class ChallengesLists extends StatefulWidget {
  const ChallengesLists({Key? key}) : super(key: key);

  @override
  _ChallengesListsState createState() => _ChallengesListsState();
}

class _ChallengesListsState extends State<ChallengesLists> {
  ChallengeCategory displayedChallenges = ChallengeCategory.active;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
        builder: (context, state) {
      if (state is ChallengeInProgress) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              child: ChallengesList(
                  category: ChallengeCategory.active,
                  onPressed: () {
                    setState(() {
                      displayedChallenges =
                          displayedChallenges == ChallengeCategory.active
                              ? ChallengeCategory.none
                              : ChallengeCategory.active;
                    });
                  },
                  title: 'Active',
                  isHighlighted:
                      displayedChallenges == ChallengeCategory.active,
                  challenges: state.activeChallenges),
            ),
            const SizedBox(height: 10),
            Flexible(
              fit: FlexFit.loose,
              child: ChallengesList(
                  category: ChallengeCategory.pending,
                  onPressed: () {
                    setState(() {
                      displayedChallenges =
                          displayedChallenges == ChallengeCategory.pending
                              ? ChallengeCategory.none
                              : ChallengeCategory.pending;
                    });
                  },
                  title: 'Pending',
                  isHighlighted:
                      displayedChallenges == ChallengeCategory.pending,
                  challenges: state.pendingChallenges),
            ),
            const SizedBox(height: 10),
            Flexible(
              fit: FlexFit.loose,
              child: ChallengesList(
                  category: ChallengeCategory.complete,
                  onPressed: () {
                    setState(() {
                      displayedChallenges =
                          displayedChallenges == ChallengeCategory.complete
                              ? ChallengeCategory.none
                              : ChallengeCategory.complete;
                    });
                  },
                  title: 'Completed',
                  isHighlighted:
                      displayedChallenges == ChallengeCategory.complete,
                  challenges: state.completedChallenges),
            )
          ],
        );
      } else {
        return Container();
      }
    });
  }
}*/

class ChallengesList extends StatelessWidget {
  const ChallengesList(
      {Key? key, required this.category, required this.challenges})
      : super(key: key);

  final ChallengeCategory category;
  final List<PuttingChallenge> challenges;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        child: challenges.isEmpty
            ? const Center(child: Text('No challenges'))
            : ListView(
                shrinkWrap: true,
                children: challenges
                    .map(
                      (challenge) => Builder(builder: (context) {
                        if (category == ChallengeCategory.pending) {
                          return PendingChallengeItem(
                            accept: () {
                              BlocProvider.of<ChallengesCubit>(context)
                                  .openChallenge(challenge);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BlocProvider.value(
                                          value:
                                              BlocProvider.of<ChallengesCubit>(
                                                  context),
                                          child:
                                              const ChallengeRecordScreen())));
                            },
                            challenge: challenge,
                          );
                        } else {
                          return PendingChallengeItem(
                              accept: () {
                                BlocProvider.of<ChallengesCubit>(context)
                                    .openChallenge(challenge);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        BlocProvider.value(
                                            value: BlocProvider.of<
                                                ChallengesCubit>(context),
                                            child:
                                                const ChallengeRecordScreen())));
                              },
                              challenge: challenge);
                        }
                      }),
                    )
                    .toList(),
              ));
  }
}
