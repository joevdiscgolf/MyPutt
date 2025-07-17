import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/components/misc/putts_made_picker.dart';
import 'package:myputt/features/training/cubit/training_cubit.dart';
import 'package:myputt/models/data/training/training_session_instructions.dart';
import 'package:myputt/services/ai/ai_coach_service.dart';
import 'package:myputt/utils/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class TrainingSessionScreen extends StatefulWidget {
  const TrainingSessionScreen({Key? key}) : super(key: key);

  @override
  State<TrainingSessionScreen> createState() => _TrainingSessionScreenState();
}

class _TrainingSessionScreenState extends State<TrainingSessionScreen> {
  int selectedPutts = 0;
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrainingCubit, TrainingState>(
      listener: (context, state) {
        if (state is TrainingSessionCompleted) {
          _showCompletionDialog(context, state);
        } else if (state is TrainingError) {
          _showErrorSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is TrainingSessionInProgress) {
          return _buildSessionInProgress(context, state);
        } else if (state is TrainingSessionLoading) {
          return _buildLoadingScreen();
        } else {
          return _buildEmptyState();
        }
      },
    );
  }

  Widget _buildSessionInProgress(BuildContext context, TrainingSessionInProgress state) {
    final currentSetIndex = state.session.currentSetIndex;
    final isComplete = state.session.allSetsCompleted;
    
    if (isComplete) {
      return _buildLoadingScreen();
    }
    
    final currentSet = state.session.instructions.trainingSets[currentSetIndex];
    
    return Scaffold(
      backgroundColor: MyPuttColors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: MyPuttColors.gray.shade50,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildProgressPanel(state),
              ),
              title: Text(
                state.session.instructions.title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: MyPuttColors.darkGray),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCoachingFeedback(state.currentFeedback),
              const SizedBox(height: 20),
              _buildCurrentSetInfo(currentSet, currentSetIndex, state.session.instructions.trainingSets.length),
              const SizedBox(height: 20),
              _buildPuttsMadePicker(currentSet.puttsRequired),
              const SizedBox(height: 20),
              _buildActionButtons(context, state),
              const SizedBox(height: 30),
              _buildGoalProgress(state.goalProgress, state.session.instructions.goals),
              const SizedBox(height: 20),
              _buildSetHistory(state.session),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressPanel(TrainingSessionInProgress state) {
    final progress = state.session.currentSetIndex / state.session.instructions.trainingSets.length;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MyPuttColors.blue.withValues(alpha: 0.8),
            MyPuttColors.blue,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Set ${state.session.currentSetIndex + 1} / ${state.session.instructions.trainingSets.length}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          LinearPercentIndicator(
            percent: progress,
            lineHeight: 8,
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            progressColor: Colors.white,
            barRadius: const Radius.circular(4),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),
          Text(
            'Overall: ${state.session.overallPercentage.toStringAsFixed(1)}%',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachingFeedback(CoachingFeedback feedback) {
    final color = _getFeedbackColor(feedback.tone);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getFeedbackIcon(feedback.tone),
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'AI Coach',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            feedback.message,
            style: TextStyle(
              color: MyPuttColors.darkGray,
              fontSize: 16,
            ),
          ),
          if (feedback.encouragement != null) ...[
            const SizedBox(height: 8),
            Text(
              feedback.encouragement!,
              style: TextStyle(
                color: MyPuttColors.darkGray.withValues(alpha: 0.8),
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentSetInfo(TrainingSet currentSet, int setIndex, int totalSets) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyPuttColors.gray.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${currentSet.distance} ft',
                style: TextStyle(
                  color: MyPuttColors.blue,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.arrow_forward,
                color: MyPuttColors.darkGray.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 16),
              Text(
                '${currentSet.puttsRequired} putts',
                style: TextStyle(
                  color: MyPuttColors.darkGray,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          if (currentSet.focusArea != null) ...[
            const SizedBox(height: 12),
            Text(
              'Focus: ${currentSet.focusArea}',
              style: TextStyle(
                color: MyPuttColors.darkGray.withValues(alpha: 0.8),
                fontSize: 16,
              ),
            ),
          ],
          if (currentSet.techniqueTip != null) ...[
            const SizedBox(height: 8),
            Text(
              currentSet.techniqueTip!,
              style: TextStyle(
                color: MyPuttColors.darkGray.withValues(alpha: 0.7),
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPuttsMadePicker(int maxPutts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How many putts did you make?',
          style: TextStyle(
            color: MyPuttColors.darkGray,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        PuttsMadePicker(
          length: maxPutts,
          sslKey: GlobalKey<ScrollSnapListState>(),
          challengeMode: false,
          onUpdate: (index) {
            setState(() {
              selectedPutts = index;
            });
            HapticFeedback.lightImpact();
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, TrainingSessionInProgress state) {
    return Row(
      children: [
        if (state.session.results.isNotEmpty)
          Expanded(
            flex: 1,
            child: _buildUndoButton(context),
          ),
        if (state.session.results.isNotEmpty) const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: _buildAddSetButton(context, state),
        ),
      ],
    );
  }

  Widget _buildAddSetButton(BuildContext context, TrainingSessionInProgress state) {
    final currentSet = state.session.instructions.trainingSets[state.session.currentSetIndex];
    
    return ElevatedButton(
      onPressed: () {
        context.read<TrainingCubit>().addSetResult(
          puttsMade: selectedPutts,
          puttsAttempted: currentSet.puttsRequired,
        );
        setState(() {
          selectedPutts = 0;
        });
        HapticFeedback.mediumImpact();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: MyPuttColors.blue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        'Add Set',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUndoButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        context.read<TrainingCubit>().undoLastSet();
        HapticFeedback.lightImpact();
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: MyPuttColors.darkGray.withValues(alpha: 0.3)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Icon(
        Icons.undo,
        color: MyPuttColors.darkGray,
      ),
    );
  }

  Widget _buildGoalProgress(GoalEvaluationResult goalProgress, List<TrainingGoal> goals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session Goals',
          style: TextStyle(
            color: MyPuttColors.darkGray,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...goals.map((goal) {
          final progress = goalProgress.goalProgress[goal.id];
          final isCompleted = progress?.isCompleted ?? false;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCompleted 
                  ? Colors.green.withValues(alpha: 0.1)
                  : MyPuttColors.gray.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isCompleted 
                    ? Colors.green.withValues(alpha: 0.3)
                    : MyPuttColors.darkGray.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isCompleted ? Icons.check_circle : Icons.circle_outlined,
                  color: isCompleted ? Colors.green : MyPuttColors.darkGray.withValues(alpha: 0.5),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.description,
                        style: TextStyle(
                          color: MyPuttColors.darkGray,
                          fontSize: 14,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      if (progress != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          progress.statusMessage,
                          style: TextStyle(
                            color: MyPuttColors.darkGray.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSetHistory(TrainingSession session) {
    if (session.results.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Completed Sets',
          style: TextStyle(
            color: MyPuttColors.darkGray,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...session.results.reversed.map((result) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MyPuttColors.gray.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${result.distance} ft',
                  style: TextStyle(
                    color: MyPuttColors.darkGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${result.puttsMade} / ${result.puttsAttempted}',
                  style: TextStyle(
                    color: MyPuttColors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${result.percentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: _getPercentageColor(result.percentage),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: MyPuttColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: MyPuttColors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              'AI Coach is analyzing...',
              style: TextStyle(
                color: MyPuttColors.darkGray,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Scaffold(
      backgroundColor: MyPuttColors.white,
      appBar: AppBar(
        backgroundColor: MyPuttColors.gray.shade50,
        title: Text(
          'Training Session',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(color: MyPuttColors.darkGray),
        ),
      ),
      body: Center(
        child: Text(
          'No active training session',
          style: TextStyle(
            color: MyPuttColors.darkGray.withValues(alpha: 0.7),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showCompletionDialog(BuildContext context, TrainingSessionCompleted state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: MyPuttColors.gray.shade50,
        title: Text(
          'Session Complete!',
          style: TextStyle(color: MyPuttColors.darkGray),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Overall Performance: ${state.session.overallPercentage.toStringAsFixed(1)}%',
              style: TextStyle(
                color: MyPuttColors.darkGray,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              state.finalGoalProgress.summary,
              style: TextStyle(
                color: MyPuttColors.darkGray.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              'Done',
              style: TextStyle(color: MyPuttColors.blue),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Color _getFeedbackColor(FeedbackTone tone) {
    switch (tone) {
      case FeedbackTone.positive:
      case FeedbackTone.celebratory:
        return Colors.green;
      case FeedbackTone.encouraging:
        return Colors.blue;
      case FeedbackTone.constructive:
        return Colors.orange;
      case FeedbackTone.neutral:
        return MyPuttColors.darkGray.withValues(alpha: 0.7);
    }
  }

  IconData _getFeedbackIcon(FeedbackTone tone) {
    switch (tone) {
      case FeedbackTone.positive:
        return Icons.thumb_up;
      case FeedbackTone.celebratory:
        return Icons.celebration;
      case FeedbackTone.encouraging:
        return Icons.favorite;
      case FeedbackTone.constructive:
        return Icons.lightbulb;
      case FeedbackTone.neutral:
        return Icons.info;
    }
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return MyPuttColors.blue;
    if (percentage >= 40) return Colors.orange;
    return Colors.red;
  }
}