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
import '../../data/types/chart/chart_point.dart';
import 'components/charts/performance_chart.dart';
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
  double _sliderValue = 1;
  late int _numSets;
  late final int totalSets;
  @override
  void initState() {
    super.initState();
    totalSets = _statsService.getTotalPuttingSets(
      _sessionRepository.allSessions,
      _challengesRepository.completedChallenges,
    );
    _numSets = totalSets;
  }

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
        body: BlocBuilder<MyProfileCubit, MyProfileState>(
          builder: (context, state) {
            if (state is MyProfileLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  await BlocProvider.of<MyProfileCubit>(context).reload();
                },
                child: ListView(children: [
                  _basicInfoPanel(context),
                  const SizedBox(height: 10),
                  _lifetimeStatsPanel(context),
                  const SizedBox(height: 10),
                  _chartPanel(context),
                  const SizedBox(height: 10),
                  const PDGAInfoPanel(),
                ]),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Widget _chartPanel(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            'Performance over time',
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(
            height: 5,
          ),
          PerformanceChart(
              data: PerformanceChartData(
                  points: _statsService.getPointsWithDistanceAndLimit(
                      _sessionRepository.allSessions,
                      _challengesRepository.completedChallenges,
                      20,
                      _numSets))),
          _chartOptionsPanel(context),
        ],
      ),
      color: Colors.white,
    );
  }

  Widget _chartOptionsPanel(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Last $_numSets ${_numSets == 1 ? 'Set' : 'Sets'}',
            style: Theme.of(context).textTheme.headline6,
          ),
          Row(
            children: [
              Expanded(
                child: Slider(
                  label: _numSets.toString(),
                  onChanged: (double newValue) {
                    setState(() {
                      _numSets = (newValue * totalSets).toInt() == 0
                          ? 1
                          : (newValue * totalSets).toInt();
                      _sliderValue = newValue;
                    });
                  },
                  value: _sliderValue,
                ),
              )
            ],
          ),
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
          return const Text('');
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
          Text('Log out'),
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
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'MyPutt info',
                            style: Theme.of(context).textTheme.headline5,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
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
                      ),
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

  Widget _lifetimeStatsPanel(BuildContext context) {
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lifetime stats',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Putts made',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 5),
                        _puttsMadeRow(context),
                        Divider(
                          height: 20,
                          thickness: 1,
                          color: Colors.grey[300],
                        ),
                        Text(
                          'Percentages',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        _circleStatsRow(context),
                        const SizedBox(
                          height: 5,
                        ),
                        Divider(
                          height: 20,
                          thickness: 1,
                          color: Colors.grey[300],
                        ),
                        Text(
                          'Challenges',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        _challengeStatsRow(context)
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
                return PercentageCircle(decimal: c1XPercentage, diameter: 60);
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
                  return PercentageCircle(decimal: c2Percentage, diameter: 60);
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
                  return PercentageCircle(decimal: c2Percentage, diameter: 60);
                })
              ],
            );
          }),
        )
      ],
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
      final double winRate =
          numWins.toDouble() / (numWins + numLosses + numDraws).toDouble();
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
                        '${(winRate * 100).toStringAsFixed(2)} %',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color:
                                winRate > 0.5 ? ThemeColors.green : Colors.red),
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
              child: const Center(child: Text('- %')));
        }
      })
    ]);
  }
}
