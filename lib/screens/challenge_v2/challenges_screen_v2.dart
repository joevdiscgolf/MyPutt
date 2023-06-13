import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/components/delegates/sliver_app_bar_delegate.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/cubits/challenges/challenges_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/challenge/components/dialogs/new_challenge_button.dart';
import 'package:myputt/screens/challenge_v2/components/challenges_v2_app_bar.dart';
import 'package:myputt/screens/challenge_v2/components/challenges_list_v2.dart';
import 'package:myputt/screens/challenge_v2/components/loading/challenges_v2_loading_screen.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/enums.dart';

class ChallengesScreenV2 extends StatefulWidget {
  const ChallengesScreenV2({Key? key}) : super(key: key);

  static String routeName = '/challenges_v2_screen';

  @override
  State<ChallengesScreenV2> createState() => _ChallengesState();
}

class _ChallengesState extends State<ChallengesScreenV2>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  final Mixpanel _mixpanel = locator.get<Mixpanel>();
  late final TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _mixpanel.track('Challenges V2 Screen Impression');
    _tabController = TabController(length: 3, vsync: this);
    _addListener();
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
      body: Stack(
        children: [
          NestedScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            body: _mainBody(context),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                    ChallengesV2AppBar(
                      topViewPadding: MediaQuery.of(context).viewPadding.top,
                      tabController: _tabController,
                    ),
                  ),
                )
              ];
            },
          ),
          const Align(
            alignment: Alignment.bottomRight,
            child: NewChallengeButton(),
          ),
        ],
      ),
    );
  }

  Widget _mainBody(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
        builder: (context, state) {
      if (state is ChallengesErrorState) {
        return EmptyState(
            onRetry: () => BlocProvider.of<ChallengesCubit>(context).reload());
      } else if (state is ChallengesLoading) {
        return const ChallengesV2LoadingScreen();
      }
      state.activeChallenges.sort(
          (c1, c2) => c1.creationTimeStamp.compareTo(c2.creationTimeStamp));
      state.incomingPendingChallenges.sort(
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
          ChallengesListV2(
            challenges: state.activeChallenges.reversed.toList(),
            challengeCategory: ChallengeCategory.active,
          ),
          ChallengesListV2(
            challenges: state.incomingPendingChallenges.reversed.toList(),
            challengeCategory: ChallengeCategory.pending,
          ),
          ChallengesListV2(
            challenges: state.completedChallenges.reversed.toList(),
            challengeCategory: ChallengeCategory.complete,
          ),
        ],
      );
    });
  }
}
