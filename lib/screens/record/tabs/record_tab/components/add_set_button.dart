import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/cubits/record/record_cubit.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';

class RecordAddSetButton extends StatelessWidget {
  const RecordAddSetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: MyPuttButton(
          title: 'Add set',
          width: double.infinity,
          height: 48,
          textSize: 16,
          fontWeight: FontWeight.w600,
          iconData: FlutterRemix.add_line,
          onPressed: () {
            final RecordState recordState =
                BlocProvider.of<RecordCubit>(context).state;

            locator.get<Mixpanel>().track(
              'Record Screen Add Set Button Pressed',
              properties: {
                'Putts Attempted': recordState.setLength,
                'Putts Made': recordState.puttsSelected,
              },
            );

            BlocProvider.of<SessionsCubit>(context).addSet(
              PuttingSet(
                timeStamp: DateTime.now().millisecondsSinceEpoch,
                puttsMade: recordState.puttsSelected,
                puttsAttempted: recordState.setLength,
                distance: recordState.distance,
                conditions: recordState.puttingConditions,
              ),
            );
          }),
    );
  }
}
