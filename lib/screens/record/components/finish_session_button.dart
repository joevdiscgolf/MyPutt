import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/dialogs/confirm_dialog.dart';
import 'package:myputt/components/misc/shadow_icon.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/utils/colors.dart';

class FinishSessionButton extends StatelessWidget {
  const FinishSessionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: MyPuttButton(
        onPressed: () {
          _onPressed(context);
        },
        width: double.infinity,
        title: 'Finish session',
        textColor: MyPuttColors.gray[300]!,
        textSize: 16,
        fontWeight: FontWeight.w600,
        backgroundColor: MyPuttColors.white,
        borderColor: MyPuttColors.gray[300]!,
        shadowColor: MyPuttColors.black.withOpacity(0.25),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    showDialog(
        context: context,
        builder: (dialogContext) => ConfirmDialog(
              title: 'Finish session',
              icon: const ShadowIcon(
                icon: Icon(
                  FlutterRemix.medal_2_fill,
                  size: 80,
                  color: MyPuttColors.black,
                ),
              ),
              buttonlabel: 'Finish',
              buttonColor: MyPuttColors.blue,
              actionPressed: () {
                // _mixpanel.track(
                //   'Record Screen Finish Session Confirmed',
                // );
                BlocProvider.of<SessionsCubit>(context).completeSession();
                // setState(() {
                //   sessionInProgress = false;
                // });
              },
            )).then((value) {
      // dialog callback
    });
  }
}
