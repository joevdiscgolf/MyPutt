import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/screens/my_profile/components/color_marker.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/enums.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChallengePerformancePanel extends StatefulWidget {
  const ChallengePerformancePanel({Key? key, required this.chartSize})
      : super(key: key);

  final double chartSize;

  @override
  State<ChallengePerformancePanel> createState() =>
      _ChallengePerformancePanelState();
}

class _ChallengePerformancePanelState extends State<ChallengePerformancePanel> {
  final ChallengesRepository _challengesRepository =
      locator.get<ChallengesRepository>();

  ChallengeResult _challengeResult = ChallengeResult.none;
  late final List<PuttingChallenge> _completedChallenges;
  late final int _wins;
  late final int _losses;
  late final int _draws;
  late final double? _winPercent;
  late List<int> _selectedIndices;
  late List<int> _allIndices;
  List<int> _spacerIndices = [];

  late final List<ChartData> _chartData;
  List<ChartData> _spacerChartData = [];

  @override
  void initState() {
    _completedChallenges = _challengesRepository.completedChallenges;
    if (_completedChallenges.isEmpty) {
      _chartData = [
        ChartData(
            value: 1,
            color: MyPuttColors.gray[200]!,
            label: 'Not complete',
            challengeResult: ChallengeResult.none)
      ];
      _winPercent = null;
      _allIndices = [0];
      _selectedIndices = _allIndices;
    } else {
      _wins = _completedChallenges
          .where((challenge) => getDifferenceFromChallenge(challenge) > 0)
          .length;
      _losses = _completedChallenges
          .where((challenge) => getDifferenceFromChallenge(challenge) < 0)
          .length;
      _draws = _completedChallenges
          .where((challenge) => getDifferenceFromChallenge(challenge) == 0)
          .length;
      _winPercent =
          (_wins.toDouble() / _completedChallenges.length.toDouble() * 100);

      _chartData = [
        if (_wins > 0)
          ChartData(
              value: _wins.toDouble(),
              color: MyPuttColors.darkBlue,
              label: 'Wins',
              challengeResult: ChallengeResult.win),
        if (_losses > 0)
          ChartData(
              value: _losses.toDouble(),
              color: MyPuttColors.red,
              label: 'Losses',
              challengeResult: ChallengeResult.loss),
        if (_draws > 0)
          ChartData(
              value: _draws.toDouble(),
              color: MyPuttColors.gray,
              label: 'Draws',
              challengeResult: ChallengeResult.draw),
      ];
      for (int i = 0; i < _chartData.length; i++) {
        final ChartData data = _chartData[i];
        _spacerChartData.add(data);
        _spacerChartData.add(ChartData(
            challengeResult: ChallengeResult.none,
            value: _completedChallenges.length * 0.02,
            color: Colors.transparent,
            label: 'spacer'));
        _spacerIndices.add(i * 2 + 1);
      }
      _allIndices = [for (int i = 0; i < _spacerChartData.length; i++) i];
      _selectedIndices = _allIndices;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Center(child: _pieChart(context)),
            Center(
              child: SizedBox(
                height: widget.chartSize,
                width: widget.chartSize,
                child: Center(child: _centerMessage(context)),
              ),
            )
          ],
        ),
        const SizedBox(
          width: 16,
        ),
        _legend(context)
      ],
    );
  }

  Widget _legend(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            ColorMarker(
              color: MyPuttColors.darkBlue,
              size: 16,
            ),
            SizedBox(
              width: 4,
            ),
            SizedBox(width: 40, child: Text('Wins')),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: const [
            ColorMarker(
              color: MyPuttColors.red,
              size: 16,
            ),
            SizedBox(
              width: 4,
            ),
            SizedBox(width: 40, child: Text('Losses')),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: const [
            ColorMarker(
              color: MyPuttColors.gray,
              size: 16,
            ),
            SizedBox(
              width: 4,
            ),
            SizedBox(width: 40, child: Text('Draws')),
          ],
        ),
      ],
    );
  }

  Widget _centerMessage(BuildContext context) {
    return Bounceable(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
        setState(() {
          _selectedIndices = _allIndices;
          _challengeResult = ChallengeResult.none;
        });
      },
      child: Container(
        height: widget.chartSize * 0.6,
        width: widget.chartSize * 0.6,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Center(
          child: Builder(builder: (context) {
            if (_completedChallenges.isEmpty) {
              return AutoSizeText(
                'No challenges yet',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 28, color: MyPuttColors.gray[800]),
                maxLines: 1,
              );
            } else if (_challengeResult == ChallengeResult.none) {
              return AutoSizeText(
                '${_winPercent?.toStringAsFixed(0)}% \n win rate',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 28, color: MyPuttColors.gray[800]),
                maxLines: 2,
                textAlign: TextAlign.center,
              );
            } else {
              return Builder(
                builder: (BuildContext context) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        '${getChallengeResultText()}\n${challengeResultToCount()}',
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                            fontSize: 28, color: MyPuttColors.gray[800]),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              );
            }
          }),
        ),
      ),
    );
  }

  String getChallengeResultText() {
    switch (_challengeResult) {
      case ChallengeResult.win:
        return 'Wins';
      case ChallengeResult.loss:
        return 'Losses';
      default:
        return 'Draws';
    }
  }

  int challengeResultToCount() {
    switch (_challengeResult) {
      case ChallengeResult.win:
        return _wins;
      case ChallengeResult.loss:
        return _losses;
      default:
        return _draws;
    }
  }

  Widget _pieChart(BuildContext context) {
    return SizedBox(
      height: widget.chartSize,
      width: widget.chartSize,
      child: SfCircularChart(
        selectionGesture: ActivationMode.singleTap,
        onSelectionChanged: (SelectionArgs args) => _onSelection(args),
        series: <CircularSeries>[
          DoughnutSeries<ChartData, String>(
              animationDuration: 0,
              selectionBehavior: SelectionBehavior(
                enable: true,
                unselectedColor: MyPuttColors.gray[200],
              ),
              initialSelectedDataIndexes: _selectedIndices,
              explodeGesture: ActivationMode.none,
              radius: '100%',
              innerRadius: '80%',
              cornerStyle: CornerStyle.bothFlat,
              dataSource: _spacerChartData,
              strokeWidth: 30,
              pointColorMapper: (ChartData data, _) => data.color,
              xValueMapper: (ChartData data, _) => data.label,
              yValueMapper: (ChartData data, _) => data.value)
        ],
      ),
    );
  }

  void _onSelection(SelectionArgs args) {
    final int index = args.pointIndex;
    if (_spacerChartData[index].challengeResult != ChallengeResult.none) {
      Vibrate.feedback(FeedbackType.light);
      setState(() {
        _challengeResult = _spacerChartData[index].challengeResult;
        _selectedIndices = [index];
        _selectedIndices.addAll(_spacerIndices);
      });
    } else {
      List<int> selected = [index];
      selected.addAll(_selectedIndices);
      setState(() {
        _selectedIndices = selected;
      });
    }
  }
}

class ChartData {
  ChartData(
      {required this.challengeResult,
      required this.value,
      required this.color,
      required this.label});
  final ChallengeResult challengeResult;
  final double value;
  final Color color;
  final String label;
}
