import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants/distance_constants.dart';
import 'package:myputt/utils/enums.dart';

class DistancePickerDoubleSlider extends StatefulWidget {
  const DistancePickerDoubleSlider({super.key});

  @override
  State<DistancePickerDoubleSlider> createState() =>
      _DistancePickerDoubleSliderState();
}

class _DistancePickerDoubleSliderState
    extends State<DistancePickerDoubleSlider> {
  late final ValueNotifier<RangeValues> _rangeValuesNotifier;

  @override
  void initState() {
    final HomeScreenV2State homeScreenV2State =
        BlocProvider.of<HomeScreenV2Cubit>(context).state;
    final PuttingCircle initialSelectedCircle =
        homeScreenV2State.selectedCircle;

    _rangeValuesNotifier = ValueNotifier(RangeValues(
      kCircleToMinDistance[initialSelectedCircle]!,
      kCircleToMaxDistance[initialSelectedCircle]!,
    ));

    if (homeScreenV2State is HomeScreenV2Loaded) {
      _rangeValuesNotifier.value = homeScreenV2State.distanceRangeValues;
    }
    super.initState();
  }

  @override
  void dispose() {
    _rangeValuesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeScreenV2Cubit, HomeScreenV2State>(
      listener: (context, homeScreenV2State) {
        setState(() {
          _rangeValuesNotifier.value = RangeValues(
            kCircleToMinDistance[homeScreenV2State.selectedCircle]!,
            kCircleToMaxDistance[homeScreenV2State.selectedCircle]!,
          );
        });
      },
      listenWhen: (previous, current) =>
          previous.selectedCircle != current.selectedCircle,
      builder: (context, homeScreenV2State) {
        final PuttingCircle selectedCircle = homeScreenV2State.selectedCircle;

        return ValueListenableBuilder<RangeValues>(
          valueListenable: _rangeValuesNotifier,
          builder: (_, rangeValues, __) {
            final double minDistance = kCircleToMinDistance[selectedCircle]!;
            final double maxDistance = kCircleToMaxDistance[selectedCircle]!;

            if (isOutOfRange(rangeValues, selectedCircle)) {
              rangeValues = RangeValues(minDistance, maxDistance);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Distance',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: MyPuttColors.darkGray,
                                  ),
                        ),
                      ),
                      Text(
                        rangeValues.start == rangeValues.end
                            ? '${rangeValues.start.toInt()} ft'
                            : '${rangeValues.start.toInt()} - ${rangeValues.end.toInt()} ft',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: MyPuttColors.darkGray,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: RangeSlider(
                    values: rangeValues,
                    onChanged: (RangeValues updatedValues) {
                      _rangeValuesNotifier.value = updatedValues;
                    },
                    divisions: maxDistance.toInt() - minDistance.toInt(),
                    onChangeEnd: (RangeValues updatedValues) {
                      BlocProvider.of<HomeScreenV2Cubit>(context)
                          .updateDistanceRangeValues(updatedValues);
                    },
                    min: minDistance,
                    max: maxDistance,
                    activeColor: MyPuttColors.blue,
                    inactiveColor: MyPuttColors.blue.withOpacity(0.4),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  bool isOutOfRange(RangeValues rangeValues, PuttingCircle selectedCircle) {
    return rangeValues.start < kCircleToMinDistance[selectedCircle]! ||
        rangeValues.end > kCircleToMaxDistance[selectedCircle]!;
  }
}
