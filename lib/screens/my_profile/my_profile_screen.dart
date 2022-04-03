import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/components/misc/frisbee_circle_icon.dart';
import 'package:myputt/components/screens/loading_screen.dart';
import 'package:myputt/cubits/my_profile_cubit.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/home/components/stats_view/rows/components/shadow_circular_indicator.dart';
import 'package:myputt/screens/my_profile/components/challenge_performance_panel.dart';
import 'package:myputt/screens/my_profile/components/edit_profile_frisbee_panel.dart';
import 'package:myputt/screens/my_profile/components/lifetime_stat_row.dart';
import 'package:myputt/services/signin_service.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/utils/challenge_helpers.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'components/pdga_info_panel.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final ChallengesRepository _challengesRepository =
      locator.get<ChallengesRepository>();
  final SessionRepository _sessionRepository = locator.get<SessionRepository>();
  final StatsService _statsService = locator.get<StatsService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyPuttColors.white,
        body: BlocBuilder<MyProfileCubit, MyProfileState>(
          builder: (context, state) {
            if (state is MyProfileLoaded) {
              final List<Widget> bodyChildren = [
                _basicInfoPanel(context),
                _percentagesPanel(context),
                const SizedBox(height: 8),
                _lifetimeStats(context),
                const SizedBox(
                  height: 8,
                ),
                const SizedBox(height: 20),
                ChallengePerformancePanel(
                  chartSize: MediaQuery.of(context).size.width / 1.8,
                ),
                const SizedBox(
                  height: 20,
                ),
                const PDGAInfoPanel(),
                const SizedBox(
                  height: 16,
                )
              ];
              return RefreshIndicator(
                onRefresh: () async {
                  await BlocProvider.of<MyProfileCubit>(context).reload();
                },
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (context, index) => bodyChildren[index],
                          childCount: bodyChildren.length),
                    ),
                  ],
                ),
              );
            } else if (state is MyProfileInitial) {
              return const LoadingScreen();
            } else {
              return EmptyState(
                  onRetry: () =>
                      BlocProvider.of<MyProfileCubit>(context).reload());
            }
          },
        ));
  }

  Widget _logoutButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: MyPuttButton(
        onPressed: () {
          BlocProvider.of<MyProfileCubit>(context).signOut();
          locator.get<SigninService>().signOut();
        },
        padding: const EdgeInsets.all(8),
        height: 50,
        title: 'Log out',
        iconData: FlutterRemix.logout_box_line,
        iconColor: MyPuttColors.darkGray,
        color: Colors.transparent,
        textColor: MyPuttColors.darkGray,
      ),
    );
  }

  Widget _basicInfoPanel(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
        builder: (context, state) {
      if (state is MyProfileLoaded) {
        return Container(
          padding: const EdgeInsets.only(top: 32),
          decoration: const BoxDecoration(
              color: MyPuttColors.blue,
              gradient: LinearGradient(
                  transform: GradientRotation(pi / 2),
                  end: Alignment(0.5, 0),
                  colors: [MyPuttColors.skyBlue, MyPuttColors.white])),
          child: Row(
            children: [
              Expanded(
                child: Container(
                    padding: const EdgeInsets.all(0),
                    // margin: const EdgeInsets.all(0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: _logoutButton(context),
                        ),
                        Bounceable(
                          onTap: () {
                            Vibrate.feedback(FeedbackType.light);
                            showBarModalBottomSheet(
                              context: context,
                              duration: const Duration(milliseconds: 200),
                              enableDrag: true,
                              isDismissible: true,
                              topControl: Container(),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(36),
                                  topRight: Radius.circular(36),
                                ),
                              ),
                              builder: (BuildContext context) =>
                                  EditProfileFrisbeePanel(
                                initialBackgroundColorHex: state.myUser
                                        .frisbeeAvatar?.backgroundColorHex ??
                                    '2196F3',
                                initialFrisbeeIconColor: state
                                    .myUser.frisbeeAvatar?.frisbeeIconColor,
                              ),
                            );
                          },
                          child: Builder(builder: (context) {
                            final double size =
                                MediaQuery.of(context).size.width / 4;
                            return SizedBox(
                              height: size + 20,
                              width: size + 20,
                              child: Center(
                                child: FrisbeeCircleIcon(
                                  frisbeeAvatar: state.myUser.frisbeeAvatar,
                                  size: size,
                                  iconSize: size * 0.8,
                                ),
                              ),
                            );
                          }),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FlutterRemix.pencil_fill,
                              color: MyPuttColors.gray[400],
                              size: 20,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Edit',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                      color: MyPuttColors.darkGray,
                                      fontSize: 16),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          state.myUser.displayName,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  color: MyPuttColors.lightBlue, fontSize: 40),
                        ),
                        Text(
                          '@${state.myUser.username}',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  color: MyPuttColors.gray[300], fontSize: 16),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        );
      } else {
        return EmptyState(onRetry: () async {
          await BlocProvider.of<MyProfileCubit>(context).reload();
        });
      }
    });
  }

  Widget _percentagesPanel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 20, bottom: 16, left: 20, right: 20),
          child: Text(
            'Percentages',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontSize: 16, color: MyPuttColors.darkGray),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                offset: const Offset(0, 4),
                color: MyPuttColors.gray[400]!,
                blurRadius: 4)
          ], color: MyPuttColors.gray[50]),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Builder(builder: (context) {
                          final double? c1XPercentage =
                              _statsService.getPercentageWithCutoff(
                                  _sessionRepository.allSessions,
                                  _challengesRepository.completedChallenges,
                                  Cutoffs.c1x);
                          return ShadowCircularIndicator(
                              decimal: c1XPercentage, size: 80);
                        }),
                        const SizedBox(height: 12),
                        Text('Circle 1X',
                            style: Theme.of(context).textTheme.headline6),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Builder(builder: (context) {
                      return Column(
                        children: [
                          Builder(builder: (context) {
                            final double? c2Percentage =
                                _statsService.getPercentageWithCutoff(
                                    _sessionRepository.allSessions,
                                    _challengesRepository.completedChallenges,
                                    Cutoffs.c2);
                            return ShadowCircularIndicator(
                                decimal: c2Percentage, size: 80);
                          }),
                          const SizedBox(height: 12),
                          Text('Circle 2',
                              style: Theme.of(context).textTheme.headline6),
                        ],
                      );
                    }),
                  ),
                  Expanded(
                    child: Builder(builder: (context) {
                      return Column(
                        children: [
                          Builder(builder: (context) {
                            final double? c2Percentage =
                                _statsService.getPercentageWithCutoff(
                                    _sessionRepository.allSessions,
                                    _challengesRepository.completedChallenges,
                                    Cutoffs.none);
                            return ShadowCircularIndicator(
                                decimal: c2Percentage, size: 80);
                          }),
                          const SizedBox(height: 12),
                          Text('All',
                              style: Theme.of(context).textTheme.headline6),
                        ],
                      );
                    }),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _lifetimeStats(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
      builder: (context, state) {
        if (state is MyProfileLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 16, left: 20, right: 20),
                child: Text(
                  'Lifetime Stats',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontSize: 16, color: MyPuttColors.darkGray),
                ),
              ),
              LifetimeStatRow(
                  icon: const Image(
                    image: AssetImage(blueFrisbeeIconSrc),
                    height: 24,
                    width: 24,
                  ),
                  title: 'Total putts',
                  subtitle:
                      '${_statsService.getPuttCountFromSessions(_sessionRepository.allSessions, true) + _statsService.getPuttCountFromChallenges(filterDuplicateChallenges(_sessionRepository.allSessions, _challengesRepository.completedChallenges), true)}/${_statsService.getPuttCountFromSessions(_sessionRepository.allSessions, false) + _statsService.getPuttCountFromChallenges(filterDuplicateChallenges(_sessionRepository.allSessions, _challengesRepository.completedChallenges), false)}'),
              const SizedBox(
                height: 4,
              ),
              LifetimeStatRow(
                  icon: const Icon(
                    FlutterRemix.bar_chart_2_fill,
                    color: MyPuttColors.blue,
                    size: 32,
                  ),
                  title: 'Sessions completed',
                  subtitle: '${_sessionRepository.allSessions.length}'),
              const SizedBox(
                height: 4,
              ),
              LifetimeStatRow(
                  icon: const Icon(
                    FlutterRemix.sword_fill,
                    color: MyPuttColors.blue,
                    size: 32,
                  ),
                  title: 'Challenges completed',
                  subtitle:
                      '${_challengesRepository.completedChallenges.length}'),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
