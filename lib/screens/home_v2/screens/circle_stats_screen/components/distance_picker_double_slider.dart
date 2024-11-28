import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/home/home_screen_cubit.dart';
import 'package:myputt/utils/colors.dart';

class DistancePickerDoubleSlider extends StatefulWidget {
  const DistancePickerDoubleSlider({super.key});

  @override
  State<DistancePickerDoubleSlider> createState() =>
      _DistancePickerDoubleSliderState();
}

class _DistancePickerDoubleSliderState
    extends State<DistancePickerDoubleSlider> {
  late final ValueNotifier<RangeValues> rangeValuesNotifier =
      ValueNotifier(const RangeValues(0, 100));

  @override
  void initState() {
    super.initState();
    final HomeScreenState homeScreenState =
        BlocProvider.of<HomeScreenCubit>(context).state;
    if (homeScreenState is HomeScreenLoaded) {
      rangeValuesNotifier.value = homeScreenState.distanceRangeValues;
    }
  }

  @override
  void dispose() {
    rangeValuesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Distance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: MyPuttColors.gray[400],
                ),
          ),
        ),
        ValueListenableBuilder<RangeValues>(
          valueListenable: rangeValuesNotifier,
          builder: (_, rangeValues, __) {
            return Column(
              children: [
                RangeSlider(
                  values: rangeValues,
                  onChanged: (RangeValues updatedValues) {
                    rangeValuesNotifier.value = updatedValues;
                  },
                  divisions: 100,
                  onChangeEnd: (RangeValues updatedValues) {
                    BlocProvider.of<HomeScreenCubit>(context)
                        .updateDistanceRangeValues(updatedValues);
                  },
                  min: 0,
                  max: 100,
                ),
                const SizedBox(height: 16),
                Text(
                  '${rangeValues.start.toInt()} - ${rangeValues.end.toInt()} ft',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
