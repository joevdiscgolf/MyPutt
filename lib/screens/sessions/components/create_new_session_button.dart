import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter/services.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/record/record_screen.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/layout_helpers.dart';

class CreateNewSessionButton extends StatelessWidget {
  const CreateNewSessionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, right: 8),
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<SessionsCubit, SessionsState>(
        builder: (context, state) {
          if (state is! SessionActive) {
            return Bounceable(
              onTap: () {
                HapticFeedback.lightImpact();
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
                  boxShadow: standardBoxShadow(),
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
      ),
    );
  }
}
