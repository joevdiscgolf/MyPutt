import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/cubits/my_profile_cubit.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/signin_service.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/theme/theme_data.dart';
import 'package:myputt/utils/constants.dart';

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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: _title(context),
        actions: [
          _logoutButton(context),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _basicInfoPanel(context),
          const SizedBox(height: 10),
          _careerStatsPanel(context)
        ],
      ),
    );
  }

  Widget _title(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
      builder: (context, state) {
        if (state is MyProfileLoaded) {
          return Text(state.myUser.displayName);
        } else {
          return const Text('Loading');
        }
      },
    );
  }

  Widget _logoutButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
      ),
      onPressed: () {
        locator.get<SigninService>().signOut();
      },
      child: Row(
        children: const [
          Icon(
            FlutterRemix.logout_box_line,
            size: 15,
          ),
          SizedBox(width: 5),
          Text('Logout'),
        ],
      ),
    );
  }

  Widget _basicInfoPanel(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
        builder: (context, state) {
      if (state is MyProfileLoaded) {
        return Row(
          children: [
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const DefaultProfileCircle(),
                      Text(
                        'Username \n${state.myUser.username}',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Sessions \n${_sessionRepository.allSessions.length}',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Challenges \n ${_challengesRepository.completedChallenges.length}',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      )
                    ],
                  )),
            ),
          ],
        );
      } else {
        return Row(
          children: const [
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          ],
        );
      }
    });
  }

  Widget _careerStatsPanel(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
      builder: (context, state) {
        if (state is MyProfileLoaded) {
          return Row(
            children: [
              Expanded(
                child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Lifetime stats',
                              style: Theme.of(context).textTheme.headline5,
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        _puttsMadeRow(context),
                        const SizedBox(
                          height: 10,
                        ),
                        _circleStatsRow(context)
                      ],
                    )),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _puttsMadeRow(BuildContext context) {
    return Row(
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
                    style: Theme.of(context).textTheme.headline6,
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
                    style: Theme.of(context).textTheme.headline6,
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
                    style: Theme.of(context).textTheme.headline6,
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
    );
  }

  Widget _circleStatsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text('Circle 1X', style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 5),
              Builder(builder: (context) {
                final double? c1XPercentage =
                    _statsService.getPercentagesWithCutoff(
                        _sessionRepository.allSessions,
                        _challengesRepository.completedChallenges,
                        Cutoffs.c1x);
                return _percentageCircle(c1XPercentage, 60);
              })
            ],
          ),
        ),
        Expanded(
          child: Builder(builder: (context) {
            return Column(
              children: [
                Text('Circle 2', style: Theme.of(context).textTheme.headline6),
                const SizedBox(height: 5),
                Builder(builder: (context) {
                  final double? c2Percentage =
                      _statsService.getPercentagesWithCutoff(
                          _sessionRepository.allSessions,
                          _challengesRepository.completedChallenges,
                          Cutoffs.c2);
                  return _percentageCircle(c2Percentage, 60);
                })
              ],
            );
          }),
        ),
        Expanded(
          child: Builder(builder: (context) {
            return Column(
              children: [
                Text('All distances',
                    style: Theme.of(context).textTheme.headline6),
                const SizedBox(height: 5),
                Builder(builder: (context) {
                  final double? c2Percentage =
                      _statsService.getPercentagesWithCutoff(
                          _sessionRepository.allSessions,
                          _challengesRepository.completedChallenges,
                          Cutoffs.none);
                  return _percentageCircle(c2Percentage, 60);
                })
              ],
            );
          }),
        )
      ],
    );
  }

  Widget _percentageCircle(double? decimal, double diameter) {
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
                  color: ThemeColors.green,
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
              color: ThemeColors.green,
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
              child: Center(child: const Text('- %')));
        }
      })
    ]);
  }
}
