import 'package:flutter/material.dart';
import 'package:myputt/screens/home/components/putting_stats_page.dart';
import 'package:myputt/screens/home/components/enums.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static String routeName = '/';

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.grey[100]!,
          appBar: AppBar(
              backgroundColor: Colors.lightBlueAccent[200],
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Text('Circle 1')),
                  Tab(icon: Text('Circle 2')),
                ],
              ),
              title: const Text('MyPutt',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold))),
          body: const TabBarView(children: [
            PuttingStatsPage(
                circle: Circles.circle1, timeRange: TimeRange.lastFive),
            PuttingStatsPage(
                circle: Circles.circle2, timeRange: TimeRange.lastFive),
          ])),
    );
  }
}
