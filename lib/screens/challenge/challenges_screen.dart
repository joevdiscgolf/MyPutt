import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/screens/challenge/challenge_record/components/dialogs/challenge_result_dialog.dart';
import 'package:myputt/screens/challenge/components/challenge_category_tab.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/screens/challenge/components/challenges_list.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({Key? key}) : super(key: key);

  static String routeName = '/challenges_screen';

  @override
  _ChallengesState createState() => _ChallengesState();
}

class _ChallengesState extends State<ChallengesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    BlocProvider.of<ChallengesCubit>(context).reload();
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            backgroundColor: MyPuttColors.white,
            appBar: AppBar(
              title: Text(
                'Challenges',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 40, color: MyPuttColors.blue),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            floatingActionButton: _newChallengeButton(context),
            body: NestedScrollView(
              body: _mainBody(context),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [SliverToBoxAdapter(child: _tabBar(context))];
              },
            )));
  }

  Widget _mainBody(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: BlocBuilder<ChallengesCubit, ChallengesState>(
          builder: (context, state) {
        return TabBarView(children: [
          ChallengesList(
              category: ChallengeCategory.active,
              challenges: List.from(state.activeChallenges.reversed)),
          ChallengesList(
              category: ChallengeCategory.pending,
              challenges: List.from(state.pendingChallenges.reversed)),
          ChallengesList(
              category: ChallengeCategory.complete,
              challenges: List.from(state.completedChallenges.reversed)),
        ]);
      }),
    );
  }

  Widget _tabBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: MyPuttColors.white, boxShadow: []),
      child: const TabBar(
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: MyPuttColors.blue)),
        labelColor: MyPuttColors.blue,
        unselectedLabelColor: Colors.black,
        tabs: [
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
      ),
    );
  }

  Widget _newChallengeButton(BuildContext context) {
    return FloatingActionButton(
        child: const Icon(FlutterRemix.add_line),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) =>
                  const ChallengeResultDialog(difference: -5));
        });
  }
}
