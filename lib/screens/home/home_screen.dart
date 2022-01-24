import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/bloc/cubits/home_screen_cubit.dart';
import 'package:myputt/screens/home/components/putting_stats_page.dart';
import 'package:myputt/screens/home/components/enums.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static String routeName = '/';

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _sessionRangeIndex = 0;
  final List<String> _sessionRangeLabels = [
    'Last 5',
    'Last 20',
    'Last 50',
    'All time'
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.grey[100]!,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('MyPutt',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Text('Circle 1')),
                Tab(icon: Text('Circle 2')),
              ],
            ),
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _sessionRangeLabels
                        .asMap()
                        .entries
                        .map((entry) => Builder(builder: (context) {
                              if (_sessionRangeIndex == entry.key) {
                                return ElevatedButton(
                                    child: Text(entry.value,
                                        style: const TextStyle(
                                            color: Colors.black)),
                                    style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                            width: 2.0, color: Colors.blue),
                                        primary: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        _sessionRangeIndex = entry.key;
                                      });

                                      BlocProvider.of<HomeScreenCubit>(context)
                                          .updateSessionRange(
                                              _sessionRangeIndex);
                                      BlocProvider.of<HomeScreenCubit>(context)
                                          .reloadStats();
                                    });
                              }
                              return ElevatedButton(
                                  child: Text(entry.value),
                                  onPressed: () {
                                    setState(() {
                                      _sessionRangeIndex = entry.key;
                                    });
                                    BlocProvider.of<HomeScreenCubit>(context)
                                        .updateSessionRange(_sessionRangeIndex);
                                    BlocProvider.of<HomeScreenCubit>(context)
                                        .reloadStats();
                                  });
                            }))
                        .toList()),
              ),
              const Expanded(
                child: TabBarView(children: [
                  PuttingStatsPage(
                      circle: Circles.circle1, timeRange: TimeRange.lastFive),
                  PuttingStatsPage(
                      circle: Circles.circle2, timeRange: TimeRange.lastFive),
                ]),
              ),
            ],
          )),
    );
  }
}
