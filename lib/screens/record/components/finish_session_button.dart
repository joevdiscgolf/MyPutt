import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/components/dialogs/confirm_dialog.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/toast/toast_service.dart';
import 'package:myputt/utils/colors.dart';

class FinishSessionButton extends StatelessWidget {
  const FinishSessionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {
        _onPressed(context);
      },
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: MyPuttColors.gray[50],
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: MyPuttColors.black.withOpacity(0.25),
              offset: const Offset(0, 2),
              blurRadius: 2,
              spreadRadius: 0,
            )
          ],
        ),
        child: const Icon(
          FlutterRemix.check_line,
          color: MyPuttColors.darkGray,
          size: 16,
        ),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    Vibrate.feedback(FeedbackType.light);

    final SessionsState sessionsState =
        BlocProvider.of<SessionsCubit>(context).state;

    if (sessionsState is! SessionInProgressState) {
      return;
    }

    if (sessionsState.currentSession.sets.isEmpty) {
      locator.get<ToastService>().triggerErrorToast('No sets yet!');
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmDialog(
        title: 'Finish session',
        icon: const Icon(
          FlutterRemix.medal_2_fill,
          size: 80,
          color: MyPuttColors.black,
        ),
        buttonlabel: 'Finish',
        buttonColor: MyPuttColors.blue,
        actionPressed: () {
          locator
              .get<Mixpanel>()
              .track('Record Screen Finish Session Confirmed');
          Navigator.of(context).popUntil((route) => route.isFirst);
          BlocProvider.of<SessionsCubit>(context).completeSession();
        },
      ),
    );
  }
}
