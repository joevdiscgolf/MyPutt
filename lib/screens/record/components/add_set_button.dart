import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';

class AddSetButton extends StatelessWidget {
  const AddSetButton({Key? key}) : super(key: key);

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
            // locator.get<Mixpanel>().track(
            //   'Record Screen Add Set Button Pressed',
            //   properties: {
            //     'Putts Attempted': _setLength,
            //     'Putts Made': _focusedIndex
            //   },
            // );
            BlocProvider.of<SessionsCubit>(context).addSet(
              PuttingSet(
                timeStamp: DateTime.now().millisecondsSinceEpoch,
                puttsMade: 10,
                puttsAttempted: 10,
                distance: 10,
              ),
            );
          }),
    );
  }
}
