import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/screens/challenge/challenge_record_screen.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/screens/challenge/components/challenge_category_tab.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/screens/challenge/components/challenges_list.dart';
import 'dart:math' as math;

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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: Colors.grey[100]!,
          appBar: AppBar(
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      primary: Colors.transparent),
                  onPressed: () async {
                    await BlocProvider.of<ChallengesCubit>(context).reload();
                  },
                  child: const Center(
                    child: Icon(IconData(0xe514, fontFamily: 'MaterialIcons')),
                  ))
            ],
            title: const Text('Challenges'),
            centerTitle: true,
          ),
          body: Builder(builder: (context) {
            return Column(
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
                            ChallengeCategoryTab(
                              showCounter: true,
                              challenges: state.activeChallenges,
                              label: 'Active',
                              icon: const Icon(
                                FlutterRemix.play_mini_line,
                                size: 15,
                              ),
                            ),
                            ChallengeCategoryTab(
                              showCounter: true,
                              challenges: state.pendingChallenges,
                              label: 'Pending',
                              icon: const Icon(
                                FlutterRemix.repeat_line,
                                size: 15,
                              ),
                            ),
                            ChallengeCategoryTab(
                              showCounter: true,
                              challenges: state.completedChallenges,
                              label: 'Completed',
                              icon: const Icon(
                                FlutterRemix.check_line,
                                size: 15,
                              ),
                            ),
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
                            ChallengeCategoryTab(
                              showCounter: true,
                              challenges: state.activeChallenges,
                              label: 'Active',
                              icon: const Icon(
                                FlutterRemix.play_mini_line,
                                size: 15,
                              ),
                            ),
                            ChallengeCategoryTab(
                              showCounter: true,
                              challenges: state.pendingChallenges,
                              label: 'Pending',
                              icon: const Icon(
                                FlutterRemix.repeat_line,
                                size: 15,
                              ),
                            ),
                            ChallengeCategoryTab(
                              showCounter: true,
                              challenges: state.completedChallenges,
                              label: 'Completed',
                              icon: const Icon(
                                FlutterRemix.check_line,
                                size: 15,
                              ),
                            ),
                          ],
                        );
                      } else if (state is ChallengeComplete) {
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
                            ChallengeCategoryTab(
                              showCounter: true,
                              challenges: state.activeChallenges,
                              label: 'Active',
                              icon: const Icon(
                                FlutterRemix.play_mini_line,
                                size: 15,
                              ),
                            ),
                            ChallengeCategoryTab(
                              showCounter: true,
                              challenges: state.pendingChallenges,
                              label: 'Pending',
                              icon: const Icon(
                                FlutterRemix.repeat_line,
                                size: 15,
                              ),
                            ),
                            ChallengeCategoryTab(
                              showCounter: true,
                              challenges: state.completedChallenges,
                              label: 'Completed',
                              icon: const Icon(
                                FlutterRemix.check_line,
                                size: 15,
                              ),
                            ),
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
                            ChallengeCategoryTab(
                              showCounter: true,
                              challenges: state.activeChallenges,
                              label: 'Active',
                              icon: const Icon(
                                FlutterRemix.play_mini_line,
                                size: 15,
                              ),
                            ),
                            ChallengeCategoryTab(
                              showCounter: true,
                              challenges: state.pendingChallenges,
                              label: 'Pending',
                              icon: const Icon(
                                FlutterRemix.repeat_line,
                                size: 15,
                              ),
                            ),
                            ChallengeCategoryTab(
                              showCounter: true,
                              challenges: state.completedChallenges,
                              label: 'Completed',
                              icon: const Icon(
                                FlutterRemix.check_line,
                                size: 15,
                              ),
                            ),
                          ],
                        );
                      } else if (state is ChallengesLoading) {
                        return TabBar(
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              25.0,
                            ),
                            color: Colors.blue,
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          tabs: const [
                            ChallengeCategoryTab(
                              showCounter: true,
                              challenges: [],
                              label: 'Active',
                              icon: Icon(
                                FlutterRemix.play_mini_line,
                                size: 15,
                              ),
                            ),
                            ChallengeCategoryTab(
                              showCounter: true,
                              challenges: [],
                              label: 'Pending',
                              icon: Icon(
                                FlutterRemix.repeat_line,
                                size: 15,
                              ),
                            ),
                            ChallengeCategoryTab(
                              showCounter: true,
                              challenges: [],
                              label: 'Completed',
                              icon: Icon(
                                FlutterRemix.check_line,
                                size: 15,
                              ),
                            ),
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
                            challenges:
                                List.from(state.activeChallenges.reversed)),
                        ChallengesList(
                            category: ChallengeCategory.pending,
                            challenges:
                                List.from(state.pendingChallenges.reversed)),
                        ChallengesList(
                            category: ChallengeCategory.complete,
                            challenges:
                                List.from(state.completedChallenges.reversed)),
                      ]);
                    } else if (state is NoCurrentChallenge) {
                      return TabBarView(children: [
                        ChallengesList(
                            category: ChallengeCategory.active,
                            challenges:
                                List.from(state.activeChallenges.reversed)),
                        ChallengesList(
                            category: ChallengeCategory.pending,
                            challenges:
                                List.from(state.pendingChallenges.reversed)),
                        ChallengesList(
                            category: ChallengeCategory.complete,
                            challenges:
                                List.from(state.completedChallenges.reversed)),
                      ]);
                    } else if (state is ChallengeComplete) {
                      return TabBarView(children: [
                        ChallengesList(
                            category: ChallengeCategory.active,
                            challenges:
                                List.from(state.activeChallenges.reversed)),
                        ChallengesList(
                            category: ChallengeCategory.pending,
                            challenges:
                                List.from(state.pendingChallenges.reversed)),
                        ChallengesList(
                            category: ChallengeCategory.complete,
                            challenges:
                                List.from(state.completedChallenges.reversed)),
                      ]);
                    } else if (state is ChallengesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Container();
                    }
                  }),
                ),
              ],
            );
          })),
    );
  }
}
