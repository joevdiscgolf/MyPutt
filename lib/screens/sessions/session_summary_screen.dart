import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:intl/intl.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/cubits/session_summary_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/screens/home/components/stats_view/rows/putting_stat_row.dart';
import 'package:myputt/screens/my_profile/components/stat_row.dart';
import 'package:myputt/screens/record/components/rows/putting_set_row.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';

class SessionSummaryScreen extends StatefulWidget {
  const SessionSummaryScreen({
    Key? key,
    required this.session,
  }) : super(key: key);

  final PuttingSession session;

  @override
  _SessionSummaryScreenState createState() => _SessionSummaryScreenState();
}

class _SessionSummaryScreenState extends State<SessionSummaryScreen> {
  final Mixpanel _mixpanel = locator.get<Mixpanel>();

  @override
  void initState() {
    super.initState();
    _mixpanel.track('Session Summary Screen Impression');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyPuttColors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: MyPuttColors.darkGray,
          ),
          title: Text(
            'Session',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 28, color: MyPuttColors.blue),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: BlocBuilder<SessionSummaryCubit, SessionSummaryState>(
          builder: (context, state) {
            if (state is SessionSummaryLoaded) {
              final Map<int, num> allPercentages = {};
              final Map<int, num> allTimePercentages = {};
              if (state.stats.circleOnePercentages != null) {
                for (MapEntry entry
                    in state.stats.circleOnePercentages!.entries) {
                  if (entry.value != null) {
                    allPercentages[entry.key] = entry.value!;
                  }
                  if (state.stats.circleOneOverall?[entry.key] != null) {
                    allTimePercentages[entry.key] =
                        state.stats.circleOneOverall![entry.key]!;
                  }
                }
              }
              if (state.stats.circleTwoPercentages != null) {
                for (MapEntry entry
                    in state.stats.circleTwoPercentages!.entries) {
                  if (entry.value != null) {
                    allPercentages[entry.key] = entry.value!;
                  }
                  if (state.stats.circleTwoOverall?[entry.key] != null) {
                    allTimePercentages[entry.key] =
                        state.stats.circleTwoOverall![entry.key]!;
                  }
                }
              }

              return _mainBody(
                  context, allPercentages, allTimePercentages, state.session);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ));
  }

  Widget _mainBody(BuildContext context, Map<int, num> allPercentages,
      Map<int, num?> allTimePercentages, PuttingSession session) {
    List<Widget> children = [];
    for (int i = 0; i < allPercentages.entries.length; i++) {
      final MapEntry entry = allPercentages.entries.toList()[i];
      children.add(PuttingStatRow(
        distance: entry.key,
        percentage: entry.value,
        backgroundColor:
            i % 2 == 0 ? MyPuttColors.white : MyPuttColors.gray[50]!,
        allTimePercentage: allTimePercentages[entry.key] ?? entry.value,
      ));
    }
    children.addAll(List.from(widget.session.sets
        .asMap()
        .entries
        .map((entry) => PuttingSetRow(
              set: entry.value,
              index: entry.key,
              deletable: false,
              delete: () {},
            ))
        .toList()
        .reversed));

    final int totalAttempted = totalAttemptsFromSets(session.sets);
    final int totalMade = totalMadeFromSets(session.sets);

    return NestedScrollView(
      body: ListView(
        children: children,
      ),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: Column(children: [
              const SizedBox(height: 12),
              StatRow(
                  title: 'Date',
                  icon: const Icon(
                    FlutterRemix.calendar_check_fill,
                    color: MyPuttColors.blue,
                    size: 28,
                  ),
                  subtitle:
                      '${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(session.timeStamp)).toString()}, ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(session.timeStamp)).toString()}'),
              const SizedBox(height: 4),
              StatRow(
                icon: const Image(
                  image: AssetImage(blueFrisbeeIconSrc),
                ),
                title: 'Putts Made',
                subtitle: '$totalMade/$totalAttempted',
              ),
              const SizedBox(height: 4),
            ]),
          )
        ];
      },
    );
  }
}
