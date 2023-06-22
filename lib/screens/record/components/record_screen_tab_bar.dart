import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/screens/record/components/record_screen_app_bar.dart';
import 'package:myputt/utils/colors.dart';

class RecordScreenTabBar extends StatefulWidget {
  const RecordScreenTabBar({Key? key, required this.tabController})
      : super(key: key);

  final TabController tabController;

  @override
  State<RecordScreenTabBar> createState() => _RecordScreenTabBarState();
}

class _RecordScreenTabBarState extends State<RecordScreenTabBar> {
  @override
  void dispose() {
    widget.tabController.removeListener(_tabListener);
    super.dispose();
  }

  @override
  void initState() {
    widget.tabController.addListener(_tabListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: RecordScreenAppBar.tabBarHeight,
      child: Stack(
        children: [
          Container(
            height: RecordScreenAppBar.tabBarHeight,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: MyPuttColors.gray[200]!, width: 2),
              ),
            ),
          ),
          SizedBox(
            height: RecordScreenAppBar.tabBarHeight,
            child: TabBar(
              controller: widget.tabController,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(color: MyPuttColors.darkGray, width: 2),
              ),
              labelPadding: const EdgeInsets.symmetric(vertical: 12),
              indicatorWeight: 2,
              indicatorColor: MyPuttColors.gray[800]!,
              onTap: (_) {
                Vibrate.feedback(FeedbackType.light);
              },
              tabs: [
                Text(
                  'Record',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: widget.tabController.index == 0
                            ? MyPuttColors.darkGray
                            : MyPuttColors.gray[400],
                        fontWeight: FontWeight.w600,
                      ),
                ),
                BlocBuilder<SessionsCubit, SessionsState>(
                  builder: (context, state) {
                    late final int numSets;
                    if (state is SessionActive) {
                      numSets = state.currentSession.sets.length;
                    } else {
                      numSets = 0;
                    }
                    return _setsTabTitle(context, numSets);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _setsTabTitle(BuildContext context, int numSets) {
    final bool isSelected = widget.tabController.index == 1;

    final TextStyle? style = Theme.of(context).textTheme.titleSmall?.copyWith(
          color: widget.tabController.index == 1
              ? MyPuttColors.darkGray
              : MyPuttColors.gray[300],
          fontWeight: FontWeight.w600,
        );

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$numSets ',
            style: style?.copyWith(
              color: MyPuttColors.blue.withOpacity(isSelected ? 1 : 0.5),
            ),
          ),
          TextSpan(
            text: numSets == 1 ? 'Set' : 'Sets',
            style: style?.copyWith(
              color:
                  isSelected ? MyPuttColors.gray[800] : MyPuttColors.gray[400],
            ),
          ),
        ],
      ),
    );
  }

  void _tabListener() {
    setState(() {});
  }
}
