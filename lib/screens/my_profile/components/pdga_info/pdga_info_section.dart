import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/cubits/my_profile_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/my_profile/components/pdga_info/pdga_number_dialog.dart';
import 'package:myputt/screens/my_profile/components/pdga_info/pdga_stat_grid.dart';
import 'package:myputt/utils/colors.dart';

class PDGAInfoSection extends StatelessWidget {
  const PDGAInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: BlocBuilder<MyProfileCubit, MyProfileState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _header(context, state),
                      Align(
                        alignment: Alignment.centerRight,
                        child: MyPuttButton(
                          onPressed: () {
                            locator.get<Mixpanel>().track(
                                  'My Profile Screen Edit PDGA Number Button Pressed',
                                );
                            showDialog(
                              context: context,
                              builder: (context) => PdgaNumberDialog(
                                onSubmit: (String pdgaNumber) {
                                  locator.get<Mixpanel>().track(
                                    'My Profile Screen New PDGA Number Submitted',
                                    properties: {'PDGA Number': pdgaNumber},
                                  );
                                  return BlocProvider.of<MyProfileCubit>(
                                          context)
                                      .submitPDGANumber(pdgaNumber);
                                },
                              ),
                            );
                          },
                          backgroundColor: Colors.transparent,
                          iconData: FlutterRemix.pencil_line,
                          iconColor: MyPuttColors.blue,
                          title: '',
                          textColor: MyPuttColors.blue,
                        ),
                      )
                    ],
                  ),
                ),
                _mainBody(context, state)
              ],
            );
          },
        ));
  }

  Widget _header(BuildContext context, MyProfileState state) {
    if (state is MyProfileLoaded &&
        state.pdgaPlayerInfo?.pdgaNum != null &&
        state.pdgaPlayerInfo?.name != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello,',
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontSize: 20,
                  color: MyPuttColors.gray[400],
                ),
            maxLines: 1,
          ),
          const SizedBox(height: 4),
          AutoSizeText(
            state.pdgaPlayerInfo!.name!,
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontSize: 20,
                  color: MyPuttColors.darkGray,
                ),
            maxLines: 1,
          ),
        ],
      );
    } else {
      return AutoSizeText(
        'PDGA player info',
        style: Theme.of(context).textTheme.headline6?.copyWith(
              fontSize: 20,
              color: MyPuttColors.darkGray,
            ),
        maxLines: 2,
      );
    }
  }

  Widget _mainBody(BuildContext context, MyProfileState state) {
    if (state is MyProfileLoaded) {
      if (state.pdgaPlayerInfo == null && state.myUser.pdgaNum == null) {
        return Column(
          children: [
            const SizedBox(height: 10),
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
      } else if (state.pdgaPlayerInfo == null && state.myUser.pdgaNum != null) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Something went wrong,\n Ensure your PDGA number is valid.',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        return PDGAStatGrid(playerInfo: state.pdgaPlayerInfo!);
      }
    } else {
      return Container();
    }
  }
}
