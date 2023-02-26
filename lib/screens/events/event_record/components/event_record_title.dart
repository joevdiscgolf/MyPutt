import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/events/event_detail_cubit.dart';
import 'package:myputt/utils/colors.dart';

class EventRecordTitle extends StatelessWidget {
  const EventRecordTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventDetailCubit, EventDetailState>(
      builder: (context, state) {
        if (state is! EventDetailLoaded) {
          return Container();
        }
        return Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                  text: 'Set ',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: MyPuttColors.darkGray,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                ),
                TextSpan(
                  text:
                      '${state.currentPlayerData.sets.length == state.event.eventCustomizationData.challengeStructure.length ? state.currentPlayerData.sets.length : state.currentPlayerData.sets.length + 1}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: MyPuttColors.darkBlue,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                ),
                TextSpan(
                  text:
                      '/${state.event.eventCustomizationData.challengeStructure.length}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
