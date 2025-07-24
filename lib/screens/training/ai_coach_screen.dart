import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/features/training/cubit/training_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/training/training_session_instructions.dart';
import 'package:myputt/screens/training/training_session_screen.dart';
import 'package:myputt/services/ai/ai_coach_service.dart';
import 'package:myputt/utils/colors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:myputt/models/data/stats/stats.dart';

class AICoachScreen extends StatefulWidget {
  const AICoachScreen({super.key});

  static const String routeName = '/ai-coach';
  static const String screenName = 'AI Coach';

  @override
  State<AICoachScreen> createState() => _AICoachScreenState();
}

class _AICoachScreenState extends State<AICoachScreen> {
  List<TrainingSession> trainingHistory = [];
  PerformanceAnalysis? performanceAnalysis;

  @override
  void initState() {
    super.initState();
    _loadPerformanceAnalysis();
  }

  Future<Stats?> _getStats() async {
    final sessionsState = BlocProvider.of<SessionsCubit>(context).state;
    if (sessionsState is SessionActive) {
      final statsService = locator.get<StatsService>();
      return statsService.getStatsForRange(10, sessionsState.sessions, []);
    }
    return null;
  }

  Future<void> _loadPerformanceAnalysis() async {
    final sessionsState = BlocProvider.of<SessionsCubit>(context).state;
    final statsService = locator.get<StatsService>();
    final aiService = locator.get<AICoachService>();

    if (sessionsState is SessionActive) {
      try {
        final stats =
            statsService.getStatsForRange(10, sessionsState.sessions, []);
        final analysis = await aiService.analyzePerformance(
          recentSessions: sessionsState.sessions.take(10).toList(),
          userStats: stats,
        );

        setState(() {
          performanceAnalysis = analysis;
        });
      } catch (e) {
        // Failed to load performance analysis
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyPuttColors.white,
      appBar: AppBar(
        backgroundColor: MyPuttColors.gray.shade50,
        title: Text(
          'AI Coach',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: MyPuttColors.darkGray),
        ),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadPerformanceAnalysis,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuickActions(context),
              const SizedBox(height: 24),
              _buildPerformanceOverview(),
              const SizedBox(height: 24),
              _buildAnalysisSection(),
              const SizedBox(height: 24),
              _buildTrainingHistory(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            color: MyPuttColors.darkGray,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          title: 'Start AI Training',
          subtitle: 'Get a personalized putting session',
          icon: Icons.smart_toy,
          color: MyPuttColors.blue,
          onTap: () => _startAITraining(context),
        ),
        const SizedBox(height: 8),
        _buildActionCard(
          title: 'Repeat Last Session',
          subtitle: 'Practice your previous training',
          icon: Icons.replay,
          color: Colors.orange,
          onTap: trainingHistory.isNotEmpty
              ? () => _repeatSession(context, trainingHistory.first)
              : null,
        ),
        const SizedBox(height: 8),
        _buildActionCard(
          title: 'Custom Session',
          subtitle: 'Create your own training plan',
          icon: Icons.edit,
          color: Colors.purple,
          onTap: () => _createCustomSession(context),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;

    return Material(
      color: MyPuttColors.gray.shade50,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isEnabled
                  ? color.withValues(alpha: 0.3)
                  : MyPuttColors.darkGray.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isEnabled
                      ? color.withValues(alpha: 0.1)
                      : MyPuttColors.darkGray.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isEnabled
                      ? color
                      : MyPuttColors.darkGray.withValues(alpha: 0.3),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isEnabled
                            ? MyPuttColors.darkGray
                            : MyPuttColors.darkGray.withValues(alpha: 0.5),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: MyPuttColors.darkGray
                            .withValues(alpha: isEnabled ? 0.7 : 0.3),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: isEnabled
                    ? MyPuttColors.darkGray.withValues(alpha: 0.3)
                    : MyPuttColors.darkGray.withValues(alpha: 0.1),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceOverview() {
    return FutureBuilder<Stats?>(
      future: _getStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final stats = snapshot.data!;
        final totalMade = stats.generalStats?.totalMade ?? 0;
        final totalAttempts = stats.generalStats?.totalAttempts ?? 0;
        final overallPercentage =
            totalAttempts > 0 ? (totalMade / totalAttempts * 100) : 0.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Overview',
              style: TextStyle(
                color: MyPuttColors.darkGray,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: MyPuttColors.gray.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircularPercentIndicator(
                    radius: 60,
                    lineWidth: 12,
                    percent: overallPercentage / 100,
                    center: Text(
                      '${overallPercentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: MyPuttColors.darkGray,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    progressColor: _getPercentageColor(overallPercentage),
                    backgroundColor:
                        MyPuttColors.darkGray.withValues(alpha: 0.1),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overall Putting',
                          style: TextStyle(
                            color: MyPuttColors.darkGray,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildStatRow(
                            'Total Made', stats.generalStats?.totalMade ?? 0),
                        _buildStatRow('Total Attempts',
                            stats.generalStats?.totalAttempts ?? 0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: MyPuttColors.darkGray.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              color: MyPuttColors.darkGray,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisSection() {
    if (performanceAnalysis == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Analysis',
          style: TextStyle(
            color: MyPuttColors.darkGray,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: MyPuttColors.gray.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                performanceAnalysis!.summary,
                style: TextStyle(
                  color: MyPuttColors.darkGray,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              if (performanceAnalysis!.strengths.isNotEmpty) ...[
                _buildAnalysisCategory(
                  'Strengths',
                  performanceAnalysis!.strengths,
                  Colors.green,
                ),
                const SizedBox(height: 12),
              ],
              if (performanceAnalysis!.areasForImprovement.isNotEmpty) ...[
                _buildAnalysisCategory(
                  'Areas to Improve',
                  performanceAnalysis!.areasForImprovement,
                  Colors.orange,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisCategory(String title, List<String> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(
                      color: MyPuttColors.darkGray.withValues(alpha: 0.7),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        color: MyPuttColors.darkGray.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildTrainingHistory() {
    if (trainingHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Training History',
          style: TextStyle(
            color: MyPuttColors.darkGray,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...trainingHistory.take(5).map((session) => _buildHistoryCard(session)),
      ],
    );
  }

  Widget _buildHistoryCard(TrainingSession session) {
    final completedGoals =
        session.goalCompletions.values.where((v) => v).length;
    final totalGoals = session.instructions.goals.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _repeatSession(context, session),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: MyPuttColors.gray.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.instructions.title,
                      style: TextStyle(
                        color: MyPuttColors.darkGray,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${session.overallPercentage.toStringAsFixed(1)}% • $completedGoals/$totalGoals goals',
                      style: TextStyle(
                        color: MyPuttColors.darkGray.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.replay,
                color: MyPuttColors.darkGray.withValues(alpha: 0.3),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startAITraining(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildDifficultyDialog(context),
    );
  }

  Widget _buildDifficultyDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: MyPuttColors.gray.shade50,
      title: Text(
        'Select Difficulty',
        style: TextStyle(color: MyPuttColors.darkGray),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: DifficultyLevel.values.map((difficulty) {
          return ListTile(
            title: Text(
              _getDifficultyName(difficulty),
              style: TextStyle(color: MyPuttColors.darkGray),
            ),
            subtitle: Text(
              _getDifficultyDescription(difficulty),
              style: TextStyle(
                color: MyPuttColors.darkGray.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
            onTap: () {
              _generateAndStartSession(context, difficulty);
            },
          );
        }).toList(),
      ),
    );
  }

  Future<void> _generateAndStartSession(
    BuildContext context,
    DifficultyLevel difficulty,
  ) async {
    try {
      final sessionsState = BlocProvider.of<SessionsCubit>(context).state;
      final trainingCubit = context.read<TrainingCubit>();

      // Navigate immediately to show loading screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TrainingSessionScreen(),
        ),
      );

      // Generate training session in background (non-blocking)
      trainingCubit.generateTrainingSession(
        puttingHistory: sessionsState.sessions,
        difficulty: difficulty,
        targetDurationMinutes: 30,
      ).then((_) {
        final trainingState = trainingCubit.state;
        if (trainingState is TrainingInstructionsGenerated) {
          trainingCubit.startTrainingSession(trainingState.instructions);
        }
      }).catchError((e, trace) {
        print('Error generating training session: $e');
        print(trace);
      });
    } catch (e, trace) {
      print(e);
      print(trace);
    }
  }

  void _repeatSession(BuildContext context, TrainingSession session) async {
    final trainingCubit = context.read<TrainingCubit>();
    await trainingCubit.startTrainingSession(session.instructions);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TrainingSessionScreen(),
      ),
    );
  }

  void _createCustomSession(BuildContext context) {
    // TODO: Implement custom session creation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Custom session creation coming soon!'),
        backgroundColor: MyPuttColors.blue,
      ),
    );
  }

  String _getDifficultyName(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return 'Beginner';
      case DifficultyLevel.intermediate:
        return 'Intermediate';
      case DifficultyLevel.advanced:
        return 'Advanced';
      case DifficultyLevel.expert:
        return 'Expert';
    }
  }

  String _getDifficultyDescription(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return 'Focus on short putts and fundamentals';
      case DifficultyLevel.intermediate:
        return 'Balance of short and medium range putts';
      case DifficultyLevel.advanced:
        return 'Challenging distances and goals';
      case DifficultyLevel.expert:
        return 'Maximum difficulty with long putts';
    }
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return MyPuttColors.blue;
    if (percentage >= 40) return Colors.orange;
    return Colors.red;
  }
}
