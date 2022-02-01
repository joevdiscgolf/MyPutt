import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/bloc/cubits/home_screen_cubit.dart';
import 'package:myputt/screens/home/components/putting_stats_page.dart';
import 'package:myputt/screens/home/components/enums.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/signin_service.dart';

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
    BlocProvider.of<HomeScreenCubit>(context).reloadStats();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.grey[100]!,
          appBar: AppBar(
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {
                  locator.get<SigninService>().signOut();
                },
                child: const Text('Logout'),
              )
            ],
            backgroundColor: Colors.blue,
            title: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.headline4,
                children: const [
                  TextSpan(text: 'My', style: TextStyle(color: Colors.white)),
                  TextSpan(text: 'Putt', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Text('Circle 1')),
                Tab(icon: Text('Circle 2')),
              ],
            ),
          ),
          body: Column(
            children: [
              _sessionRangeRow(context),
              const Expanded(
                child: TabBarView(children: [
                  PuttingStatsPage(
                    circle: Circles.circle1,
                    timeRange: TimeRange.lastFive,
                    screenType: 'home',
                  ),
                  PuttingStatsPage(
                    circle: Circles.circle2,
                    timeRange: TimeRange.lastFive,
                    screenType: 'home',
                  ),
                ]),
              ),
            ],
          )),
    );
  }

  Widget _sessionRangeRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _sessionRangeLabels
              .asMap()
              .entries
              .map((entry) => Builder(builder: (context) {
                    if (_sessionRangeIndex == entry.key) {
                      return ElevatedButton(
                          child: Text(entry.value,
                              style: const TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                  width: 2.0, color: Colors.blue),
                              primary: Colors.white),
                          onPressed: () {
                            setState(() {
                              _sessionRangeIndex = entry.key;
                            });

                            BlocProvider.of<HomeScreenCubit>(context)
                                .updateSessionRange(_sessionRangeIndex);
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
    );
  }
}
