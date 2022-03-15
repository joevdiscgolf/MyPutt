import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ChallengesCubit>(context).reload();
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            backgroundColor: Colors.grey[100]!,
            appBar: AppBar(
              title: const Text('Challenges'),
              centerTitle: true,
            ),
            floatingActionButton: _newChallengeButton(context),
            body: _mainBody(context)));
  }

  Widget _mainBody(BuildContext context) {
    return CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        controller: _scrollController,
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: () async {
            Vibrate.feedback(FeedbackType.light);
            await BlocProvider.of<ChallengesCubit>(context).reload();
          }),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: _tabBar(context),
                    ),
                    BlocBuilder<ChallengesCubit, ChallengesState>(
                        builder: (context, state) {
                      return Expanded(
                        child: TabBarView(children: [
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
                              challenges: List.from(
                                  state.completedChallenges.reversed)),
                        ]),
                      );
                    }),
                  ],
                ),
              );
            }),
          )
        ]);
  }

  Widget _tabBar(BuildContext context) {
    return TabBar(
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(
          16,
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
