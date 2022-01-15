import 'package:flutter/material.dart';
import './components/percentage_row.dart';
import './../data/types/putt_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final PuttData _puttData = PuttData(
      distancePercentages: {10: 0.9, 15: 0.8, 20: 0.7, 25: 0.65, 30: 0.50});
  final percentages = {10: 0.9, 15: 0.8, 20: 0.7, 25: 0.65, 30: 0.50};

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: Center(child: _mainBody(context))));
  }

  Widget _mainBody(BuildContext) {
    return Column(
        children: percentages.entries
            .map((entry) => const PercentageRow(distance: 10, percentage: 0.5))
            .toList());
  }
}
