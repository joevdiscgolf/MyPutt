import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/events/event_compete_cubit.dart';
import 'package:myputt/utils/colors.dart';

class EventRecordTitle extends StatelessWidget {
  const EventRecordTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCompeteCubit, EventCompeteState>(
      builder: (context, state) {
        if (state is! EventCompeteActive) {
          return Container();
        }
        return Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                  text: 'Set ',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: MyPuttColors.darkGray,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                ),
                TextSpan(
                  text:
                      '${state.eventPlayerData.sets.length == state.event.eventCustomizationData.challengeStructure.length ? state.eventPlayerData.sets.length : state.eventPlayerData.sets.length + 1}',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: MyPuttColors.darkBlue,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                ),
                TextSpan(
                  text:
                      '/${state.event.eventCustomizationData.challengeStructure.length}',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: MyPuttColors.darkGray,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                )
              ]),
            ));
      },
    );
  }
}
