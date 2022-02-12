import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:intl/intl.dart';
import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/theme/theme_data.dart';

import '../../../components/confirm_dialog.dart';
import '../../../cubits/challenges_cubit.dart';

class PendingChallengeItem extends StatelessWidget {
  const PendingChallengeItem(
      {Key? key, required this.challenge, required this.accept})
      : super(key: key);

  final PuttingChallenge challenge;
  final Function accept;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Colors.grey[400]!),
        ),
        padding: const EdgeInsets.all(8),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 10),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(challenge.challengerUid,
                    style: Theme.of(context).textTheme.bodyLarge),
                Text(
                    DateFormat.yMMMMd('en_US')
                        .format(DateTime.fromMillisecondsSinceEpoch(
                            challenge.creationTimeStamp))
                        .toString(),
                    style: Theme.of(context).textTheme.bodyLarge),
                Text(
                    DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(
                        challenge.creationTimeStamp)),
                    style: Theme.of(context).textTheme.bodyLarge),
              ]),
              VerticalDivider(
                thickness: 1,
                color: Colors.grey[400]!,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: ThemeColors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(48),
                        ),
                        enableFeedback: true),
                    onPressed: () {
                      accept();
                    },
                    child: const Center(
                      child: Text('Accept'),
                    )),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(48),
                            ),
                            enableFeedback: true),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => ConfirmDialog(
                                    title: 'Decline Challenge',
                                    actionPressed: () {
                                      BlocProvider.of<ChallengesCubit>(context)
                                          .declineChallenge(challenge);
                                    },
                                    confirmColor: Colors.red,
                                    buttonlabel: 'Decline',
                                  ));
                        },
                        child: const Center(child: Text('Decline'))),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
