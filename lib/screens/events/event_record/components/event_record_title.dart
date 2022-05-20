import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/events/events_cubit.dart';
import 'package:myputt/utils/colors.dart';

class EventRecordTitle extends StatelessWidget {
  const EventRecordTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsCubit, EventsState>(
      builder: (context, state) {
        if (state is! ActiveEventState) {
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
                      '${state.eventPlayerData.sets.length == state.event.challengeStructure.length ? state.eventPlayerData.sets.length : state.eventPlayerData.sets.length + 1}',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: MyPuttColors.darkBlue,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                ),
                TextSpan(
                  text: '/${state.event.challengeStructure.length}',
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
