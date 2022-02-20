import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/cubits/my_profile_cubit.dart';
import 'package:myputt/data/types/pdga_player_info.dart';
import 'package:myputt/screens/my_profile/components/submit_text_dialog.dart';
import 'package:myputt/components/buttons/primary_button.dart';

class PDGAInfoPanel extends StatelessWidget {
  const PDGAInfoPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        color: Colors.white,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BlocBuilder<MyProfileCubit, MyProfileState>(
                  builder: (context, state) {
                    if (state is MyProfileLoaded &&
                        state.myUser.pdgaNum != null &&
                        state.pdgaPlayerInfo?.pdgaNum != null &&
                        state.pdgaPlayerInfo?.name != null) {
                      return Text(
                        '${state.pdgaPlayerInfo?.name} # ${state.pdgaPlayerInfo?.pdgaNum}',
                        style: Theme.of(context).textTheme.headline6,
                      );
                    }
                    return Text(
                      'PDGA player info',
                      style: Theme.of(context).textTheme.headline5,
                    );
                  },
                ),
                const Spacer(),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => SubmitTextDialog(
                                title: 'Enter PDGA number',
                                onSubmit: (String pdgaNumber) {
                                  return BlocProvider.of<MyProfileCubit>(
                                          context)
                                      .submitPDGANumber(pdgaNumber);
                                },
                              ));
                    },
                    child: const Center(
                        child: Icon(
                      FlutterRemix.edit_line,
                      color: Colors.blue,
                    )))
              ],
            ),
            _mainBody(context)
          ],
        ));
  }

  Widget _mainBody(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
        builder: (context, state) {
      if (state is MyProfileLoaded) {
        if (state.pdgaPlayerInfo == null && state.myUser.pdgaNum == null) {
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: const Center(
                    child: Text(
                  'Enter your PDGA number by\n clicking the edit button above.',
                  textAlign: TextAlign.center,
                )),
              )
            ],
          );
        } else if (state.pdgaPlayerInfo == null &&
            state.myUser.pdgaNum != null) {
          return const Center(
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Something went wrong,\n Ensure your PDGA number is valid.',
                  textAlign: TextAlign.center,
                )),
          );
        } else {
          final PDGAPlayerInfo playerInfo = state.pdgaPlayerInfo!;
          return Container(
              padding: const EdgeInsets.all(8),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text('Class',
                                style: Theme.of(context).textTheme.headline6),
                            Text(state.pdgaPlayerInfo?.classification ?? 'N/A',
                                style: Theme.of(context).textTheme.bodyLarge)
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text('Rating',
                                style: Theme.of(context).textTheme.headline6),
                            Text('${playerInfo.rating ?? 'N/A'}',
                                style: Theme.of(context).textTheme.bodyLarge)
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text('Since',
                                style: Theme.of(context).textTheme.headline6),
                            Text(playerInfo.memberSince ?? 'N/A',
                                style: Theme.of(context).textTheme.bodyLarge)
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text('Events',
                                style: Theme.of(context).textTheme.headline6),
                            Text('${playerInfo.careerEvents ?? 'N/A'}',
                                style: Theme.of(context).textTheme.bodyLarge)
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text('Wins',
                                style: Theme.of(context).textTheme.headline6),
                            Text('${playerInfo.careerWins ?? 'N/A'}',
                                style: Theme.of(context).textTheme.bodyLarge)
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text('Earnings',
                                style: Theme.of(context).textTheme.headline6),
                            Text(
                              playerInfo.careerEarnings != null
                                  ? '\$${playerInfo.careerEarnings}'
                                  : 'N/A',
                              style: Theme.of(context).textTheme.bodyLarge,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('Next event: ',
                          style: Theme.of(context).textTheme.headline6),
                      Text(
                        playerInfo.nextEvent ?? 'N/A',
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  )
                ],
              ));
        }
      } else {
        return Container();
      }
    });
  }
}
