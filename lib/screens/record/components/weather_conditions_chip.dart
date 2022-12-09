import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:myputt/models/data/sessions/conditions.dart';
import 'package:myputt/utils/colors.dart';

class WeatherConditionsChip extends StatefulWidget {
  const WeatherConditionsChip({Key? key, this.initialConditions})
      : super(key: key);

  final Conditions? initialConditions;

  @override
  State<WeatherConditionsChip> createState() => _WeatherConditionsChipState();
}

class _WeatherConditionsChipState extends State<WeatherConditionsChip> {
  Conditions? weatherConditions;

  @override
  void initState() {
    weatherConditions = widget.initialConditions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {},
      child: Container(
        height: 116,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: MyPuttColors.gray[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Conditions ',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 16)),
            AutoSizeText(
              weatherConditions == null ? 'Select' : 'Windy',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: weatherConditions == null
                        ? MyPuttColors.blue
                        : MyPuttColors.darkGray,
                  ),
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }
}
