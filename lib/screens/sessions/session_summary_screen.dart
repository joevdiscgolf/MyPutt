import 'package:flutter/material.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/data/types/stats.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/bloc/cubits/sessions_cubit.dart';
import 'package:myputt/screens/home/components/putting_stats_page.dart';
import 'package:myputt/screens/record/components/putting_set_row.dart';
import 'package:myputt/screens/home/components/enums.dart';

class SessionSummaryScreen extends StatefulWidget {
  const SessionSummaryScreen(
      {Key? key, required this.session, required this.stats})
      : super(key: key);

  final PuttingSession session;
  final Stats stats;

  @override
  _SessionSummaryScreenState createState() => _SessionSummaryScreenState();
}

class _SessionSummaryScreenState extends State<SessionSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[100]!,
        appBar: AppBar(
          title: const Text('Session summary'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Text('Sets')),
              Tab(icon: Text('Stats')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _summaryBox(context),
                _setsList(context),
              ],
            ),
            Row(
              children: const [
                PuttingStatsPage(
                    circle: Circles.circle1, timeRange: TimeRange.allTime),
                PuttingStatsPage(
                    circle: Circles.circle2, timeRange: TimeRange.allTime)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _summaryBox(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.session.dateStarted,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                          '${widget.session.sets.length.toString()} sets',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: const [
                      Text('Circle 1'),
                      Text('70 %'),
                    ],
                  ),
                  Column(
                    children: const [
                      Text('Circle 2'),
                      Text('40 %'),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Putts'),
                      Text(
                          '${widget.session.totalPuttsMade} / ${widget.session.totalPuttsAttempted}'),
                    ],
                  )
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _setsList(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: widget.session.sets.isEmpty
          ? const Center(child: Text('No sets yet'))
          : ListView(
              children: List.from(widget.session.sets
                  .asMap()
                  .entries
                  .map((entry) => PuttingSetRow(
                      set: entry.value,
                      index: entry.key,
                      deletable: false,
                      delete: () {
                        BlocProvider.of<SessionsCubit>(context)
                            .deleteSet(entry.value);
                      }))
                  .toList()
                  .reversed),
            ),
    );
  }
}
