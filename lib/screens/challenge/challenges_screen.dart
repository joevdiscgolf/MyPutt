import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/challenge/components/challenge_category_tab.dart';
import 'package:myputt/screens/challenge/components/challenges_screen_app_bar.dart';
import 'package:myputt/screens/challenge/components/dialogs/select_preset_dialog.dart';
import 'package:myputt/screens/events/components/event_search_loading_screen.dart';
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
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  final Mixpanel _mixpanel = locator.get<Mixpanel>();
  late final TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _mixpanel.track('Challenges Screen Impression');
    _tabController = TabController(length: 3, vsync: this);
    _addListener();
    BlocProvider.of<ChallengesCubit>(context).reload();
  }

  void _addListener() {
    _tabController.addListener(() {
      String? tabName;
      switch (_tabController.index) {
        case 0:
          tabName = 'Active';
          break;
        case 1:
          tabName = 'Pending';
          break;
        case 2:
          tabName = 'Completed';
          break;
        default:
          break;
      }
      _mixpanel.track(
        'Challenges Screen Tab Bar Pressed',
        properties: {'Tab Name': tabName},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: MyPuttColors.white,
      appBar: const ChallengesScreenAppBar(),
      floatingActionButton: _newChallengeButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: NestedScrollView(
        body: _mainBody(context),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [SliverToBoxAdapter(child: _tabBar(context))];
        },
      ),
    );
  }

  Widget _mainBody(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
        builder: (context, state) {
      if (state is ChallengesErrorState) {
        return EmptyState(
            onRetry: () => BlocProvider.of<ChallengesCubit>(context).reload());
      } else if (state is ChallengesLoading || state is ChallengesInitial) {
        return const EventSearchLoadingScreen();
      }
      state.activeChallenges.sort(
          (c1, c2) => c1.creationTimeStamp.compareTo(c2.creationTimeStamp));
      state.pendingChallenges.sort(
          (c1, c2) => c1.creationTimeStamp.compareTo(c2.creationTimeStamp));
      state.completedChallenges.sort((c1, c2) {
        final int dateCompletedComparison = (c1.completionTimeStamp ?? 0)
            .compareTo(c2.completionTimeStamp ?? 0);
        return dateCompletedComparison != 0
            ? dateCompletedComparison
            : c1.creationTimeStamp.compareTo(c2.creationTimeStamp);
      });
      return TabBarView(
        controller: _tabController,
        children: [
          ChallengesList(
              category: ChallengeCategory.active,
              challenges: List.from(state.activeChallenges.reversed)),
          ChallengesList(
              category: ChallengeCategory.pending,
              challenges: List.from(state.pendingChallenges.reversed)),
          ChallengesList(
              category: ChallengeCategory.complete,
              challenges: List.from(state.completedChallenges.reversed)),
        ],
      );
    });
  }

  Widget _tabBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: MyPuttColors.white, boxShadow: []),
      child: TabBar(
        controller: _tabController,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: MyPuttColors.blue),
        ),
        labelColor: MyPuttColors.blue,
        unselectedLabelColor: Colors.black,
        tabs: const [
          ChallengeCategoryTab(
            showCounter: true,
            challenges: [],
            label: 'Active',
            icon: Icon(FlutterRemix.play_mini_line, size: 15),
          ),
          ChallengeCategoryTab(
            showCounter: true,
            challenges: [],
            label: 'Pending',
            icon: Icon(FlutterRemix.repeat_line, size: 15),
          ),
          ChallengeCategoryTab(
            showCounter: true,
            challenges: [],
            label: 'Completed',
            icon: Icon(FlutterRemix.check_line, size: 15),
          ),
        ],
      ),
    );
  }

  Widget _newChallengeButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MyPuttButton(
        onPressed: () {
          Vibrate.feedback(FeedbackType.light);
          _mixpanel.track('Challenges Screen New Challenge Button Pressed');
          showDialog(
            context: context,
            builder: (BuildContext context) => const SelectPresetDialog(),
          );
        },
        title: 'New challenge',
        iconData: FlutterRemix.add_line,
        backgroundColor: MyPuttColors.blue,
        textSize: 16,
        width: MediaQuery.of(context).size.width / 2,
        shadowColor: MyPuttColors.gray[400],
      ),
    );
  }
}
