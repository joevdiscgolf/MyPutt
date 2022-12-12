import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/events/event_compete_cubit.dart';
import 'package:myputt/models/data/challenges/challenge_structure_item.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/screens/challenge/challenge_record/components/animated_arrows.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class EventDirector extends StatelessWidget {
  const EventDirector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCompeteCubit, EventCompeteState>(
        builder: (context, state) {
      if (state is! EventCompeteActive) {
        return const Center(child: Text('Something went wrong'));
      }
      final List<ChallengeStructureItem> challengeStructure =
          state.event.eventCustomizationData.challengeStructure;
      final List<PuttingSet> sets = state.eventPlayerData.sets;

      final int index = sets.length == challengeStructure.length
          ? sets.length - 1
          : sets.length;

      final int distance = challengeStructure[index].distance;
      final int setLength = challengeStructure[index].setLength;
      return _mainBody(context, distance, setLength, state);
    });
  }

  Widget _mainBody(BuildContext context, int distance, int setLength,
      EventCompeteActive state) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: MyPuttColors.gray[50]!,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$distance ft',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontSize: 32),
                  ),
                  const AnimatedArrows(),
                  Text(
                    '$setLength putts',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontSize: 24),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _percentCompleteIndicator(
          context,
          begin: totalAttemptsFromSets(state.eventPlayerData.sets).toDouble() /
              totalAttemptsFromStructure(
                      state.event.eventCustomizationData.challengeStructure)
                  .toDouble(),
          end: (totalAttemptsFromSubset(state.eventPlayerData.sets,
                      state.eventPlayerData.sets.length)
                  .toDouble()) /
              totalAttemptsFromStructure(
                      state.event.eventCustomizationData.challengeStructure)
                  .toDouble(),
        ),
      ],
    );
  }

  Widget _percentCompleteIndicator(BuildContext context,
      {required double begin, required double end}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TweenAnimationBuilder<double>(
          curve: Curves.easeOutQuad,
          tween: Tween<double>(
            begin: begin,
            end: end,
          ),
          duration: const Duration(milliseconds: 400),
          builder: (context, value, _) => Row(
                children: [
                  Flexible(
                    flex: 5,
                    child: LinearPercentIndicator(
                      lineHeight: 8,
                      percent: value,
                      progressColor: MyPuttColors.gray[400],
                      backgroundColor: Colors.grey[200],
                      barRadius: const Radius.circular(2),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: Text(
                        '${(value * 100).toInt()} %',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(fontSize: 12, color: MyPuttColors.gray),
                      ),
                    ),
                  )
                ],
              )),
    );
  }
}
