import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/cubits/my_profile_cubit.dart';
import 'package:myputt/data/types/users/pdga_player_info.dart';
import 'package:myputt/screens/my_profile/components/submit_text_dialog.dart';
import 'package:myputt/utils/colors.dart';

class PDGAInfoPanel extends StatelessWidget {
  const PDGAInfoPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            margin: const EdgeInsets.only(left: 64, right: 32),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: MyPuttColors.gray[50],
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                      color: MyPuttColors.gray[400]!),
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 32),
                      BlocBuilder<MyProfileCubit, MyProfileState>(
                        builder: (context, state) {
                          if (state is MyProfileLoaded &&
                              state.myUser.pdgaNum != null &&
                              state.pdgaPlayerInfo?.pdgaNum != null &&
                              state.pdgaPlayerInfo?.name != null) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  '${state.pdgaPlayerInfo?.name}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                        fontSize: 16,
                                        color: MyPuttColors.gray[800],
                                      ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                                Text(
                                  '#${state.pdgaPlayerInfo?.pdgaNum}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                          fontSize: 12,
                                          color: MyPuttColors.gray[400]),
                                ),
                              ],
                            );
                          }
                          return Text(
                            'PDGA player info',
                            style: Theme.of(context).textTheme.headline5,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          width: 32,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                    shadowColor: Colors.transparent),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => SubmitTextDialog(
                                            title: 'Enter PDGA number',
                                            onSubmit: (String pdgaNumber) {
                                              return BlocProvider.of<
                                                      MyProfileCubit>(context)
                                                  .submitPDGANumber(pdgaNumber);
                                            },
                                          ));
                                },
                                child: const Center(
                                    child: Icon(
                                  FlutterRemix.edit_line,
                                  color: Colors.blue,
                                ))),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                _mainBody(context)
              ],
            )),
        Positioned(
          top: 0,
          left: 50,
          child: Container(
            height: 50,
            width: 50,
            color: MyPuttColors.blue,
          ),
          // child: Image(
          //   image: AssetImage(
          //       'assets/images/profile/USDGC-McBeth-1024x683.jpeg'),
          //   height: 50,
          //   width: 50,
          //   color: Colors.blue,
          // )),
        ),
      ],
    );
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
              color: MyPuttColors.gray[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            AutoSizeText(
                                state.pdgaPlayerInfo?.classification ?? 'N/A',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                        fontSize: 16,
                                        color: MyPuttColors.gray[800]),
                                maxLines: 1),
                            AutoSizeText('Class',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                        fontSize: 12,
                                        color: MyPuttColors.gray[400]),
                                maxLines: 1),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            AutoSizeText('${playerInfo.rating ?? 'N/A'}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                        fontSize: 16,
                                        color: MyPuttColors.gray[800]),
                                maxLines: 1),
                            AutoSizeText('Rating',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                        fontSize: 12,
                                        color: MyPuttColors.gray[400]),
                                maxLines: 1),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            AutoSizeText(playerInfo.memberSince ?? 'N/A',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                        fontSize: 16,
                                        color: MyPuttColors.gray[800]),
                                maxLines: 1),
                            AutoSizeText('Since',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                        fontSize: 12,
                                        color: MyPuttColors.gray[400]),
                                maxLines: 1),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            AutoSizeText('${playerInfo.careerEvents ?? 'N/A'}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                        fontSize: 16,
                                        color: MyPuttColors.gray[800]),
                                maxLines: 1),
                            AutoSizeText('Events',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                        fontSize: 12,
                                        color: MyPuttColors.gray[400]),
                                maxLines: 1),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            AutoSizeText('${playerInfo.careerWins ?? 'N/A'}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                        fontSize: 16,
                                        color: MyPuttColors.gray[800]),
                                maxLines: 1),
                            AutoSizeText('Wins',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                        fontSize: 12,
                                        color: MyPuttColors.gray[400]),
                                maxLines: 1),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            AutoSizeText(
                                playerInfo.careerEarnings != null
                                    ? '\$${playerInfo.careerEarnings}'
                                    : 'N/A',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                        fontSize: 16,
                                        color: MyPuttColors.gray[800]),
                                maxLines: 1),
                            AutoSizeText('Earnings',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                        fontSize: 12,
                                        color: MyPuttColors.gray[400]),
                                maxLines: 1),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        'Next event: ',
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                            fontSize: 16, color: MyPuttColors.gray[800]),
                        maxLines: 1,
                      ),
                      AutoSizeText(playerInfo.nextEvent ?? 'N/A',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  fontSize: 12, color: MyPuttColors.gray[400]),
                          maxLines: 1)
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
