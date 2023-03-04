import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/session_helpers.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.75,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 40),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: BlocBuilder<SessionsCubit, SessionsState>(
                builder: (context, state) {
                  late final int numSets;
                  if (state is SessionInProgressState) {
                    numSets = state.currentSession.sets.length;
                  } else {
                    numSets = 0;
                  }

                  return RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$numSets',
                          style:
                              Theme.of(context).textTheme.subtitle1?.copyWith(
                                    color: MyPuttColors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        TextSpan(
                          text: ' ${numSets == 1 ? 'Set' : 'Sets'} completed',
                          style:
                              Theme.of(context).textTheme.subtitle1?.copyWith(
                                    color: MyPuttColors.darkGray,
                                    fontWeight: FontWeight.w600,
                                  ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: MyPuttColors.gray[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _percentageLabel(context),
                          const SizedBox(height: 8),
                          Text(
                            'Percentage',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: MyPuttColors.gray[300]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: MyPuttColors.gray[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _puttsMadeLabel(context),
                          const SizedBox(height: 8),
                          Text(
                            'Putts made',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: MyPuttColors.gray[300]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _percentageLabel(BuildContext context) {
    return BlocBuilder<SessionsCubit, SessionsState>(
      builder: (context, state) {
        late final double percentage;

        if (state is SessionInProgressState) {
          percentage =
              SessionHelpers.percentageFromSession(state.currentSession);
        } else {
          percentage = 0;
        }

        return Text(
          '${(percentage * 100).toInt()}%',
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                color: MyPuttColors.blue,
                fontWeight: FontWeight.w600,
              ),
        );
      },
    );
  }

  Widget _puttsMadeLabel(BuildContext context) {
    return BlocBuilder<SessionsCubit, SessionsState>(
      builder: (context, state) {
        late final int totalMade;
        late final int totalAttempted;

        if (state is SessionInProgressState) {
          totalMade = totalMadeFromSets(state.currentSession.sets);
          totalAttempted = totalAttemptsFromSets(state.currentSession.sets);
        } else {
          totalMade = 0;
          totalAttempted = 0;
        }

        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$totalMade',
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: MyPuttColors.blue,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              TextSpan(
                text: '/$totalAttempted',
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: MyPuttColors.darkGray,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}
