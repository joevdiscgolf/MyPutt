import 'package:flutter/cupertino.dart';
import 'package:myputt/components/charts/home_screen_chart_v2_builder.dart';
import 'package:myputt/screens/home_v2/performance_chart/wrapper/components/home_chart_v2_heading.dart';
import 'package:myputt/screens/home_v2/screens/home_v2_chart_screen/home_v2_chart_screen.dart';
import 'package:myputt/utils/colors.dart';

class HomeChartV2Wrapper extends StatelessWidget {
  const HomeChartV2Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(builder: (context) => const HomeV2ChartScreen()),
        );
      },
      child: Container(
        color: MyPuttColors.darkGray,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HomeChartV2Heading(),
            SizedBox(height: 24),
            HomeScreenChartV2Builder(),
          ],
        ),
      ),
    );
  }
}
