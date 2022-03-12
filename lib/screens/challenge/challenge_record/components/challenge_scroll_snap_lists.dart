import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/data/types/challenges/challenge_structure_item.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/theme/theme_data.dart';

class ChallengeScrollSnapList extends StatefulWidget {
  const ChallengeScrollSnapList({
    Key? key,
    this.initialIndex = 0,
    required this.sslKey,
    required this.onUpdate,
    required this.isCurrentUser,
    required this.itemCount,
    required this.challengeStructure,
    required this.puttingSets,
    required this.maxSets,
    required this.challenge,
  }) : super(key: key);

  final double initialIndex;
  final GlobalKey<ScrollSnapListState> sslKey;
  final Function onUpdate;
  final bool isCurrentUser;
  final int itemCount;
  final int maxSets;
  final List<ChallengeStructureItem> challengeStructure;
  final List<PuttingSet> puttingSets;
  final PuttingChallenge challenge;

  @override
  _ChallengeScrollSnapListState createState() =>
      _ChallengeScrollSnapListState();
}

class _ChallengeScrollSnapListState extends State<ChallengeScrollSnapList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ScrollSnapList(
      initialIndex: widget.initialIndex,
      curve: Curves.easeOutBack,
      key: widget.sslKey,
      updateOnScroll: false,
      itemSize: 60,
      itemCount: widget.itemCount,
      duration: 400,
      focusOnItemTap: true,
      onItemFocus: (index) {
        widget.onUpdate(index);
      },
      itemBuilder: _buildChallengeScrollListItem,
      dynamicItemSize: true,
      allowAnotherDirection: true,
      dynamicSizeEquation: (displacement) {
        const threshold = 0;
        const maxDisplacement = 500;
        if (displacement >= threshold) {
          const slope = 1 / (-maxDisplacement);
          return slope * displacement + (1 - slope * threshold);
        } else {
          const slope = 1 / (maxDisplacement);
          return slope * displacement + (1 - slope * threshold);
        }
      },
    ));
  }

  Widget _buildChallengeScrollListItem(BuildContext context, int index) {
    if (widget.isCurrentUser) {
      if (index == widget.puttingSets.length &&
          widget.puttingSets.length < widget.maxSets) {
        return Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: ThemeColors.green,
              border: Border.all(color: Colors.grey[600]!, width: 1.5)),
        );
      } else if (index == widget.puttingSets.length + 1) {
        return SizedBox(
          width: 60,
          height: 40,
          child: Icon(
            FlutterRemix.arrow_left_line,
            color: ThemeColors.green,
          ),
        );
      } else {
        return ListItem(set: widget.puttingSets[index]);
      }
    }
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) =>
            ScaleTransition(child: child, scale: animation),
        child: index > widget.puttingSets.length - 1
            ? const EmptyListItem()
            : ListItem(
                set: widget.puttingSets[index],
              ));
  }
}

class EmptyListItem extends StatelessWidget {
  const EmptyListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey[600]!, width: 1.5)),
      width: 60,
      height: 40,
      child: const Center(child: Text('-')),
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({Key? key, required this.set}) : super(key: key);

  final PuttingSet set;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          border: Border.all(color: Colors.grey[600]!, width: 1.5)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${set.distance} ft',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('${set.puttsMade} / ${set.puttsAttempted}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class CounterScrollSnapList extends StatefulWidget {
  const CounterScrollSnapList(
      {Key? key,
      this.initialIndex = 0,
      required this.sslKey,
      required this.onUpdate,
      required this.itemCount})
      : super(key: key);

  final double initialIndex;
  final GlobalKey<ScrollSnapListState> sslKey;
  final Function onUpdate;
  final int itemCount;

  @override
  _CounterScrollSnapListState createState() => _CounterScrollSnapListState();
}

class _CounterScrollSnapListState extends State<CounterScrollSnapList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ScrollSnapList(
      initialIndex: widget.initialIndex,
      curve: Curves.easeOutBack,
      key: widget.sslKey,
      updateOnScroll: false,
      focusToItem: (index) {},
      itemSize: 60,
      itemCount: widget.itemCount,
      duration: 400,
      focusOnItemTap: true,
      onItemFocus: (index) {
        widget.onUpdate(index);
      },
      itemBuilder: _buildItem,
      allowAnotherDirection: true,
      dynamicItemSize: true,
      dynamicSizeEquation: (displacement) {
        const threshold = 0;
        const maxDisplacement = 300;
        if (displacement >= threshold) {
          const slope = 1 / (-maxDisplacement);
          return slope * displacement + (1 - slope * threshold);
        } else {
          const slope = 1 / (maxDisplacement);
          return slope * displacement + (1 - slope * threshold);
        }
      },
    ));
  }

  Widget _buildItem(BuildContext context, int index) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      width: 60,
      height: 40,
      child: FittedBox(
        child: Center(
          child: Center(
              child: Text(
            (index + 1).toString(),
          )),
        ),
      ),
    );
  }
}
