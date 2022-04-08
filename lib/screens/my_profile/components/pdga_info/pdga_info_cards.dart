import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/cubits/my_profile_cubit.dart';
import 'package:myputt/data/types/users/pdga_player_info.dart';
import 'package:myputt/screens/my_profile/components/pdga_info/pdga_number_dialog.dart';
import 'package:myputt/screens/my_profile/components/pdga_info/pdga_stat_tile.dart';
import 'package:myputt/utils/colors.dart';

class PDGAInfoCards extends StatelessWidget {
  const PDGAInfoCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<MyProfileCubit, MyProfileState>(
                    builder: (context, state) {
                      if (state is MyProfileLoaded &&
                          state.pdgaPlayerInfo?.pdgaNum != null &&
                          state.pdgaPlayerInfo?.name != null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello,',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    fontSize: 20,
                                    color: MyPuttColors.gray[400],
                                  ),
                              maxLines: 1,
                            ),
                            const SizedBox(height: 4),
                            AutoSizeText(
                              '${state.pdgaPlayerInfo?.name}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    fontSize: 20,
                                    color: MyPuttColors.darkGray,
                                  ),
                              maxLines: 1,
                            ),
                          ],
                        );
                      }
                      return AutoSizeText(
                        'PDGA player info',
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              fontSize: 20,
                              color: MyPuttColors.darkGray,
                            ),
                        maxLines: 2,
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: MyPuttButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => PdgaNumberDialog(
                                  onSubmit: (String pdgaNumber) {
                                    return BlocProvider.of<MyProfileCubit>(
                                            context)
                                        .submitPDGANumber(pdgaNumber);
                                  },
                                ));
                      },
                      color: Colors.transparent,
                      iconData: FlutterRemix.pencil_line,
                      iconColor: MyPuttColors.blue,
                      title: '',
                      textColor: MyPuttColors.blue,
                    ),
                  )
                ],
              ),
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
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: MyPuttColors.gray[50]),
                child: Center(
                    child: Text(
                  'Link your PDGA number by\n clicking the edit button above.',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontSize: 14, color: MyPuttColors.darkGray),
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
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: PdgaStatTile(
                          description: '${playerInfo.pdgaNum}',
                          value: 'PDGA Number',
                          iconData: FlutterRemix.hashtag),
                    ),
                    Expanded(
                      child: PdgaStatTile(
                          description: 'Class',
                          value: '${playerInfo.classification}',
                          iconData: FlutterRemix.medal_line),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: PdgaStatTile(
                          description: 'Rating',
                          value: '${playerInfo.rating}',
                          iconData: FlutterRemix.bar_chart_line),
                    ),
                    Expanded(
                      child: PdgaStatTile(
                          description: 'Since',
                          value: '${playerInfo.memberSince}',
                          iconData: FlutterRemix.time_line),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: PdgaStatTile(
                          description: 'Events',
                          value:
                              '${playerInfo.careerEvents} events, ${playerInfo.careerWins} wins',
                          iconData: FlutterRemix.calendar_event_fill),
                    ),
                    Expanded(
                      child: PdgaStatTile(
                          description: 'Earnings',
                          value: '\$${playerInfo.careerEarnings}',
                          iconData: FlutterRemix.money_dollar_circle_line),
                    ),
                  ],
                ),
              ],
            ),
          );
          // return Container(
          //     padding: const EdgeInsets.all(8),
          //     color: MyPuttColors.gray[50],
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Row(
          //           children: [
          //             Expanded(
          //               child: Column(
          //                 children: [
          //                   AutoSizeText(
          //                       state.pdgaPlayerInfo?.classification ?? 'N/A',
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .headline6
          //                           ?.copyWith(
          //                               fontSize: 16,
          //                               color: MyPuttColors.darkGray),
          //                       maxLines: 1),
          //                   AutoSizeText('Class',
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .headline6
          //                           ?.copyWith(
          //                               fontSize: 12,
          //                               color: MyPuttColors.gray[400]),
          //                       maxLines: 1),
          //                 ],
          //               ),
          //             ),
          //             Expanded(
          //               child: Column(
          //                 children: [
          //                   AutoSizeText('${playerInfo.rating ?? 'N/A'}',
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .headline6
          //                           ?.copyWith(
          //                               fontSize: 16,
          //                               color: MyPuttColors.darkGray),
          //                       maxLines: 1),
          //                   AutoSizeText('Rating',
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .headline6
          //                           ?.copyWith(
          //                               fontSize: 12,
          //                               color: MyPuttColors.gray[400]),
          //                       maxLines: 1),
          //                 ],
          //               ),
          //             ),
          //             Expanded(
          //               child: Column(
          //                 children: [
          //                   AutoSizeText(playerInfo.memberSince ?? 'N/A',
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .headline6
          //                           ?.copyWith(
          //                               fontSize: 16,
          //                               color: MyPuttColors.darkGray),
          //                       maxLines: 1),
          //                   AutoSizeText('Since',
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .headline6
          //                           ?.copyWith(
          //                               fontSize: 12,
          //                               color: MyPuttColors.gray[400]),
          //                       maxLines: 1),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //         const SizedBox(
          //           height: 16,
          //         ),
          //         Row(
          //           children: [
          //             Expanded(
          //               child: Column(
          //                 children: [
          //                   AutoSizeText('${playerInfo.careerEvents ?? 'N/A'}',
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .headline6
          //                           ?.copyWith(
          //                               fontSize: 16,
          //                               color: MyPuttColors.darkGray),
          //                       maxLines: 1),
          //                   AutoSizeText('Events',
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .headline6
          //                           ?.copyWith(
          //                               fontSize: 12,
          //                               color: MyPuttColors.gray[400]),
          //                       maxLines: 1),
          //                 ],
          //               ),
          //             ),
          //             Expanded(
          //               child: Column(
          //                 children: [
          //                   AutoSizeText('${playerInfo.careerWins ?? 'N/A'}',
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .headline6
          //                           ?.copyWith(
          //                               fontSize: 16,
          //                               color: MyPuttColors.darkGray),
          //                       maxLines: 1),
          //                   AutoSizeText('Wins',
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .headline6
          //                           ?.copyWith(
          //                               fontSize: 12,
          //                               color: MyPuttColors.gray[400]),
          //                       maxLines: 1),
          //                 ],
          //               ),
          //             ),
          //             Expanded(
          //               child: Column(
          //                 children: [
          //                   AutoSizeText(
          //                       playerInfo.careerEarnings != null
          //                           ? '\$${playerInfo.careerEarnings}'
          //                           : 'N/A',
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .headline6
          //                           ?.copyWith(
          //                               fontSize: 16,
          //                               color: MyPuttColors.darkGray),
          //                       maxLines: 1),
          //                   AutoSizeText('Earnings',
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .headline6
          //                           ?.copyWith(
          //                               fontSize: 12,
          //                               color: MyPuttColors.gray[400]),
          //                       maxLines: 1),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //         const SizedBox(
          //           height: 5,
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //             AutoSizeText(
          //               'Next event: ',
          //               style: Theme.of(context).textTheme.headline6?.copyWith(
          //                   fontSize: 16, color: MyPuttColors.darkGray),
          //               maxLines: 1,
          //             ),
          //             AutoSizeText(playerInfo.nextEvent ?? 'N/A',
          //                 style: Theme.of(context)
          //                     .textTheme
          //                     .headline6
          //                     ?.copyWith(
          //                         fontSize: 12, color: MyPuttColors.gray[400]),
          //                 maxLines: 1)
          //           ],
          //         )
          //       ],
          //     ));
        }
      } else {
        return Container();
      }
    });
  }
}
