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

class _TrainingSessionScreenState extends State<TrainingSessionScreen> with TickerProviderStateMixin {
  int selectedPutts = 0;
  int puttsToAttempt = 10;
  final GlobalKey<ScrollSnapListState> puttsMadePickerKey = GlobalKey();
  late TabController _tabController;
  bool _hasShownGoalsDialog = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
    
    // Initialize puttsToAttempt with recommended value if it hasn't been set for this set
    if (puttsToAttempt != currentSet.puttsRequired && currentSet.puttsRequired <= 20) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          puttsToAttempt = currentSet.puttsRequired;
          if (selectedPutts > puttsToAttempt) {
            selectedPutts = puttsToAttempt;
          }
        });
      });
    }
    
    // Show goals dialog 100ms after screen loads
    if (!_hasShownGoalsDialog) {
      _hasShownGoalsDialog = true;
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _showGoalsDialog(context, state.session.instructions.goals);
        }
      });
    }
    
    // Calculate completed goals count
    final completedGoals = state.goalProgress.goalProgress.values
        .where((progress) => progress?.isCompleted ?? false)
        .length;
    final totalGoals = state.session.instructions.goals.length;
    
    return Scaffold(
      backgroundColor: MyPuttColors.white,
      appBar: AppBar(
        backgroundColor: MyPuttColors.white,
        elevation: 0,
        toolbarHeight: 56,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: MyPuttColors.darkGray),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          state.session.instructions.title,
          style: TextStyle(
            color: MyPuttColors.darkGray,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: MyPuttColors.blue,
          unselectedLabelColor: MyPuttColors.darkGray.withValues(alpha: 0.6),
          indicatorColor: MyPuttColors.blue,
          tabs: [
            Tab(text: 'Training'),
            Tab(text: 'Goals ($completedGoals/$totalGoals)'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Main training tab
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: _buildCurrentSetInfo(currentSet, currentSetIndex, state.session.instructions.trainingSets.length),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 1,
                                  child: _buildProgressCard(state),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildCoachingFeedback(state.currentFeedback),
                            const SizedBox(height: 16),
                            _TrainingQuantityRow(
                              quantity: puttsToAttempt,
                              onIncrement: (increment) {
                                setState(() {
                                  if (increment && puttsToAttempt < 20) {
                                    puttsToAttempt++;
                                    if (selectedPutts > puttsToAttempt) {
                                      selectedPutts = puttsToAttempt;
                                    }
                                  } else if (!increment && puttsToAttempt > 1) {
                                    puttsToAttempt--;
                                    if (selectedPutts > puttsToAttempt) {
                                      selectedPutts = puttsToAttempt;
                                    }
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      // PuttsMadePicker without horizontal padding
                      _buildPuttsMadePicker(puttsToAttempt),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildSetHistory(state.session),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                // Goals tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildGoalProgress(state.goalProgress, state.session.instructions.goals),
                ),
              ],
            ),
          ),
          _buildActionButtons(context, state),
        ],
      ),
    );
  }

  Widget _buildProgressCard(TrainingSessionInProgress state) {
    final progress = state.session.currentSetIndex / state.session.instructions.trainingSets.length;
    
    return Container(
      constraints: BoxConstraints(minHeight: 120),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyPuttColors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Set ${state.session.currentSetIndex + 1} / ${state.session.instructions.trainingSets.length}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          LinearPercentIndicator(
            percent: progress,
            lineHeight: 4,
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            progressColor: Colors.white,
            barRadius: const Radius.circular(2),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 8),
          Text(
            'Overall',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12,
            ),
          ),
          Text(
            '${state.session.overallPercentage.toStringAsFixed(1)}%',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachingFeedback(CoachingFeedback feedback) {
    final color = _getFeedbackColor(feedback.tone);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MyPuttColors.gray.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MyPuttColors.gray.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getFeedbackIcon(feedback.tone),
                  color: color,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'AI Coach',
                style: TextStyle(
                  color: MyPuttColors.darkGray,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            feedback.message,
            style: TextStyle(
              color: MyPuttColors.darkGray,
              fontSize: 14,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (feedback.encouragement != null && feedback.encouragement!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              feedback.encouragement!,
              style: TextStyle(
                color: MyPuttColors.darkGray.withValues(alpha: 0.7),
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentSetInfo(TrainingSet currentSet, int setIndex, int totalSets) {
    return Container(
      constraints: BoxConstraints(minHeight: 120),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyPuttColors.gray.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${currentSet.distance} ft',
                style: TextStyle(
                  color: MyPuttColors.blue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.arrow_forward,
                color: MyPuttColors.darkGray.withValues(alpha: 0.5),
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                '$puttsToAttempt putts',
                style: TextStyle(
                  color: MyPuttColors.darkGray,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          if (currentSet.focusArea != null) ...[
            const SizedBox(height: 8),
            Text(
              'Focus: ${currentSet.focusArea}',
              style: TextStyle(
                color: MyPuttColors.darkGray.withValues(alpha: 0.8),
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (currentSet.techniqueTip != null) ...[
            const SizedBox(height: 6),
            Text(
              currentSet.techniqueTip!,
              style: TextStyle(
                color: MyPuttColors.darkGray.withValues(alpha: 0.7),
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'How many putts did you make?',
            style: TextStyle(
              color: MyPuttColors.darkGray,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: PuttsMadePicker(
            length: maxPutts,
            sslKey: puttsMadePickerKey,
            challengeMode: false,
            onUpdate: (index) {
              HapticFeedback.lightImpact();
              if (mounted) {
                setState(() {
                  selectedPutts = index;
                });
                // Update real-time feedback
                context.read<TrainingCubit>().updateRealtimeFeedback(
                  puttsMade: index,
                  puttsToAttempt: puttsToAttempt,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, TrainingSessionInProgress state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyPuttColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
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
        ),
      ),
    );
  }

  Widget _buildAddSetButton(BuildContext context, TrainingSessionInProgress state) {
    final currentSet = state.session.instructions.trainingSets[state.session.currentSetIndex];
    
    return ElevatedButton(
      onPressed: () {
        HapticFeedback.mediumImpact();
        context.read<TrainingCubit>().addSetResult(
          puttsMade: selectedPutts,
          puttsAttempted: puttsToAttempt,
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              selectedPutts = 0;
            });
          }
        });
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

  void _showGoalsDialog(BuildContext context, List<TrainingGoal> goals) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: MyPuttColors.white,
        title: Row(
          children: [
            Icon(
              Icons.flag,
              color: MyPuttColors.blue,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Session Goals',
              style: TextStyle(
                color: MyPuttColors.darkGray,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complete these goals during your training session:',
              style: TextStyle(
                color: MyPuttColors.darkGray.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            ...goals.map((goal) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.circle_outlined,
                    color: MyPuttColors.darkGray.withValues(alpha: 0.5),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      goal.description,
                      style: TextStyle(
                        color: MyPuttColors.darkGray,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Got it!',
              style: TextStyle(color: MyPuttColors.blue),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrainingQuantityRow extends StatelessWidget {
  final int quantity;
  final Function(bool) onIncrement;

  const _TrainingQuantityRow({
    Key? key,
    required this.quantity,
    required this.onIncrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Quantity',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: MyPuttColors.gray[400],
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Container(
            height: 32,
            decoration: BoxDecoration(
              color: MyPuttColors.gray[50]!,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: MyPuttColors.black.withValues(alpha: 0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 2,
                  spreadRadius: 0,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TrainingQuantityButton(
                  increment: false,
                  onTap: () => onIncrement(false),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: MyPuttColors.gray[100]!,
                ),
                SizedBox(
                  width: 32,
                  child: Text(
                    '$quantity',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: MyPuttColors.darkGray,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: MyPuttColors.gray[200]!,
                ),
                _TrainingQuantityButton(
                  increment: true,
                  onTap: () => onIncrement(true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrainingQuantityButton extends StatefulWidget {
  final bool increment;
  final VoidCallback onTap;

  const _TrainingQuantityButton({
    Key? key,
    required this.increment,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_TrainingQuantityButton> createState() => _TrainingQuantityButtonState();
}

class _TrainingQuantityButtonState extends State<_TrainingQuantityButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: _isPressed ? MyPuttColors.blue : Colors.transparent,
          borderRadius: widget.increment
              ? const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
        ),
        child: Icon(
          widget.increment ? Icons.add : Icons.remove,
          color: MyPuttColors.darkGray,
          size: 20,
        ),
      ),
    );
  }
}