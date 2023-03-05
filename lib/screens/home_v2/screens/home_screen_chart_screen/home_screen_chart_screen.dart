import 'package:flutter/material.dart';
import 'package:myputt/components/app_bars/myputt_app_bar.dart';
import 'package:myputt/screens/home_v2/components/home_screen_chart_V2/home_screen_chart_v2.dart';
import 'package:myputt/screens/home_v2/screens/home_screen_chart_screen/components/time_range_chips_row.dart';

class HomeScreenChartScreen extends StatelessWidget {
  const HomeScreenChartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyPuttAppBar(title: 'Performance'),
      body: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          children: const [
            TimeRangeChipsRow(),
            SizedBox(height: 40),
            HomeScreenChartV2(height: 240),
          ],
        ),
      ),
    );
  }
}
