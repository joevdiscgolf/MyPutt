import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/misc/frisbee_circle_icon.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/cubits/my_profile_cubit.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/screens/home/components/rows/components/shadow_circular_indicator.dart';
import 'package:myputt/screens/my_profile/components/challenge_performance_panel.dart';
import 'package:myputt/screens/my_profile/components/edit_profile_frisbee_panel.dart';
import 'package:myputt/screens/my_profile/components/lifetime_stat_row.dart';
import 'package:myputt/services/signin_service.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';
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
  final UserRepository _userRepository = locator.get<UserRepository>();

  @override
  Widget build(BuildContext context) {
    if (_userRepository.currentUser == null) {
      BlocProvider.of<MyProfileCubit>(context).reload();
    }
    return Scaffold(
        backgroundColor: MyPuttColors.white,
        body: BlocBuilder<MyProfileCubit, MyProfileState>(
          builder: (context, state) {
            if (state is MyProfileLoaded) {
              final List<Widget> bodyChidren = [
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
                  await BlocProvider.of<ChallengesCubit>(context).reload();
                },
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (context, index) => bodyChidren[index],
                          childCount: bodyChidren.length),
                    ),
                  ],
                ),
              );
            } else if (state is MyProfileInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Center(child: Text('Failed to load. Please try again'))
                ],
              );
            }
          },
        ));
  }

  Widget _logoutButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: MyPuttButton(
        onPressed: () {
          locator.get<SigninService>().signOut();
        },
        padding: const EdgeInsets.all(8),
        height: 50,
        title: 'Log out',
        iconData: FlutterRemix.logout_box_line,
        iconColor: MyPuttColors.gray[800]!,
        color: Colors.transparent,
        textColor: MyPuttColors.gray[800]!,
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
                                initialBackgroundColor: MyPuttColors.blue,
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
                                      color: MyPuttColors.gray[800],
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
        return Container();
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
                ?.copyWith(fontSize: 16, color: MyPuttColors.gray[800]),
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
                              _statsService.getPercentagesWithCutoff(
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
                                _statsService.getPercentagesWithCutoff(
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
                                _statsService.getPercentagesWithCutoff(
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
                      ?.copyWith(fontSize: 16, color: MyPuttColors.gray[800]),
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
                      '${_statsService.getPuttCountFromSessions(_sessionRepository.allSessions, true) /*+ _statsService.getPuttCountFromChallenges(_challengesRepository.completedChallenges, true)*/}/${_statsService.getPuttCountFromSessions(_sessionRepository.allSessions, false) /*+ _statsService.getPuttCountFromChallenges(_challengesRepository.completedChallenges, false)*/}'),
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

  Widget _puttsMadeRow(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(5)),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      blueFrisbeeImageIcon,
                      Text(
                        'Total',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(fontSize: 15),
                      ),
                    ],
                  ),
                  Text(
                    '${_statsService.getPuttCountFromSessions(_sessionRepository.allSessions, true) + _statsService.getPuttCountFromChallenges(_challengesRepository.completedChallenges, true)}/${_statsService.getPuttCountFromSessions(_sessionRepository.allSessions, false) + _statsService.getPuttCountFromChallenges(_challengesRepository.completedChallenges, false)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 2,
              color: Colors.grey[400]!,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      blueFrisbeeImageIcon,
                      Text(
                        'Sessions',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(fontSize: 15),
                      ),
                    ],
                  ),
                  Text(
                    '${_statsService.getPuttCountFromSessions(_sessionRepository.allSessions, true)}/${_statsService.getPuttCountFromSessions(_sessionRepository.allSessions, false)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 2,
              color: Colors.grey[400]!,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      blueFrisbeeImageIcon,
                      Text(
                        'Challenges',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(fontSize: 15),
                      ),
                    ],
                  ),
                  Text(
                    '${_statsService.getPuttCountFromChallenges(_challengesRepository.completedChallenges, true)}/${_statsService.getPuttCountFromChallenges(_challengesRepository.completedChallenges, false)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _challengeStatsRow(BuildContext context) {
    return Builder(builder: (context) {
      final int numWins = _statsService.getNumChallengesWithResult(
          _challengesRepository.completedChallenges, ChallengeResult.win);
      final int numLosses = _statsService.getNumChallengesWithResult(
          _challengesRepository.completedChallenges, ChallengeResult.loss);
      final int numDraws = _statsService.getNumChallengesWithResult(
          _challengesRepository.completedChallenges, ChallengeResult.draw);
      final int numChallenges = numWins + numLosses + numDraws;
      final double winRate = numWins.toDouble() / numChallenges.toDouble();
      return Container(
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(5)),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      Text(
                        'Wins',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        numWins.toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ),
                ),
              ),
              VerticalDivider(
                thickness: 2,
                width: 1,
                color: Colors.grey[400]!,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      Text(
                        'Losses',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        numLosses.toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ),
                ),
              ),
              VerticalDivider(
                thickness: 2,
                width: 1,
                color: Colors.grey[400]!,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      Text(
                        'Draws',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        numDraws.toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ),
                ),
              ),
              VerticalDivider(
                thickness: 2,
                width: 1,
                color: Colors.grey[400]!,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      Text(
                        'Win rate',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        '${numChallenges == 0 ? '-' : (winRate * 100).toStringAsFixed(2)} %',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: winRate > 0.5
                                ? MyPuttColors.green
                                : Colors.red),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class PercentageCircle extends StatelessWidget {
  const PercentageCircle(
      {Key? key, required this.diameter, required this.decimal})
      : super(key: key);

  final double? decimal;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Builder(builder: (context) {
        if (decimal != null) {
          return SizedBox(
              width: diameter,
              height: diameter,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: decimal),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, _) => CircularProgressIndicator(
                  color: MyPuttColors.green,
                  backgroundColor: Colors.grey[200],
                  value: value,
                  strokeWidth: 5,
                ),
              ));
        } else {
          return SizedBox(
            width: diameter,
            height: diameter,
            child: CircularProgressIndicator(
              color: MyPuttColors.green,
              backgroundColor: Colors.grey[200],
              value: 0,
              strokeWidth: 5,
            ),
          );
        }
      }),
      Builder(builder: (context) {
        if (decimal != null) {
          return SizedBox(
            height: diameter,
            width: diameter,
            child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: decimal),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, _) => Center(
                    child: (Text((value * 100).round().toString() + ' %')))),
          );
        } else {
          return SizedBox(
              height: diameter,
              width: diameter,
              child: const Center(child: Text('- %')));
        }
      })
    ]);
  }
}
