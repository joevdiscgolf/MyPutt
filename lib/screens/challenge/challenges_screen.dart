import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/screens/challenge/challenge_record_screen.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/screens/challenge/components/challenge_category_tab.dart';
import 'components/pending_challenge_item.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/screens/challenge/components/challenges_list.dart';

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
                          ChallengeCategoryTab(
                            challenges: state.activeChallenges,
                            label: 'Active',
                            icon: const Icon(
                              FlutterRemix.play_mini_line,
                              size: 15,
                            ),
                          ),
                          ChallengeCategoryTab(
                            challenges: state.pendingChallenges,
                            label: 'Pending',
                            icon: const Icon(
                              FlutterRemix.repeat_line,
                              size: 15,
                            ),
                          ),
                          ChallengeCategoryTab(
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
                            challenges: state.activeChallenges,
                            label: 'Active',
                            icon: const Icon(
                              FlutterRemix.play_mini_line,
                              size: 15,
                            ),
                          ),
                          ChallengeCategoryTab(
                            challenges: state.pendingChallenges,
                            label: 'Pending',
                            icon: const Icon(
                              FlutterRemix.repeat_line,
                              size: 15,
                            ),
                          ),
                          ChallengeCategoryTab(
                            challenges: state.completedChallenges,
                            label: 'Completed',
                            icon: const Icon(
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
