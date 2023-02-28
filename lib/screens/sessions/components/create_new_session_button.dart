import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/record/record_screen.dart';
import 'package:myputt/utils/colors.dart';

class CreateNewSessionButton extends StatelessWidget {
  const CreateNewSessionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionsCubit, SessionsState>(
      builder: (context, state) {
        if (state is! SessionInProgressState) {
          return Bounceable(
            onTap: () {
              Vibrate.feedback(FeedbackType.light);
              locator.get<Mixpanel>().track(
                'Sessions Screen New Session Button Pressed',
                properties: {'Session Count': state.sessions.length},
              );
              BlocProvider.of<SessionsCubit>(context).startNewSession();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => BlocProvider.value(
                    value: BlocProvider.of<SessionsCubit>(context),
                    child: const RecordScreen(),
                  ),
                ),
              );
            },
            child: Container(
              alignment: Alignment.center,
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MyPuttColors.gray[800]!,
              ),
              child: const Icon(
                FlutterRemix.add_fill,
                color: MyPuttColors.white,
                size: 32,
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
