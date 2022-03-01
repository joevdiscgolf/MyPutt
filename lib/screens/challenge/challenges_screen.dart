import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/screens/challenge/components/challenge_category_tab.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/screens/challenge/components/challenges_list.dart';

import 'components/dialogs/select_preset_dialog.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({Key? key}) : super(key: key);

  static String routeName = '/challenges_screen';

  @override
  _ChallengesState createState() => _ChallengesState();
}

class _ChallengesState extends State<ChallengesScreen> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ChallengesCubit>(context).reload();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: Colors.grey[100]!,
          appBar: AppBar(
            actions: [_reloadButton(context)],
            title: const Text('Challenges'),
            centerTitle: true,
          ),
          floatingActionButton: _newChallengeButton(context),
          body: Builder(builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: BlocBuilder<ChallengesCubit, ChallengesState>(
                    builder: (context, state) {
                      if (state is ChallengeInProgress) {
                        return _tabBar(context);
                      } else if (state is NoCurrentChallenge) {
                        return _tabBar(context);
                      } else if (state is ChallengeComplete) {
                        return _tabBar(context);
                      } else if (state is NoCurrentChallenge) {
                        return _tabBar(context);
                      } else if (state is ChallengesLoading) {
                        return _tabBar(context);
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

  Widget _tabBar(BuildContext context) {
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
  }

  Widget _reloadButton(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent, primary: Colors.transparent),
        onPressed: () async {
          setState(() {
            _loading = true;
          });
          await BlocProvider.of<ChallengesCubit>(context).reload();
          Future.delayed(const Duration(milliseconds: 1000), () {
            setState(() {
              _loading = false;
            });
          });
        },
        child: Row(
          children: [
            SizedBox(
              height: 15,
              width: 15,
              child: Center(
                child: Visibility(
                    visible: _loading,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    )),
              ),
            ),
            const SizedBox(width: 10),
            const SizedBox(
                height: 25,
                width: 25,
                child: Center(
                  child: Icon(IconData(0xe514, fontFamily: 'MaterialIcons')),
                )),
          ],
        ));
  }

  Widget _newChallengeButton(BuildContext context) {
    return FloatingActionButton(
        child: const Icon(FlutterRemix.add_line),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => const SelectPresetDialog());
        });
  }
}
