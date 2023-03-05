import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/screens/home_v2/components/home_screen_chart_V2/home_screen_chart_v2.dart';
import 'package:myputt/utils/colors.dart';

class HomeScreenChartV2Wrapper extends StatelessWidget {
  const HomeScreenChartV2Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
      },
      child: Container(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _puttsMadeRow(context),
            const SizedBox(height: 16),
            const HomeScreenChartV2(),
          ],
        ),
      ),
    );
  }

  Widget _puttsMadeRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Putts made (%)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: MyPuttColors.gray[300],
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Text(
            '24 ft',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: MyPuttColors.blue,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(width: 4),
          Icon(
            FlutterRemix.arrow_right_s_line,
            size: 20,
            color: MyPuttColors.gray[400],
          ),
        ],
      ),
    );
  }
}
