import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/data/types/challenges/challenge_structure_item.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/theme/theme_data.dart';

class ChallengeScrollSnapList extends StatefulWidget {
  const ChallengeScrollSnapList({
    Key? key,
    required this.sslKey,
    required this.onUpdate,
    required this.isCurrentUser,
    required this.itemCount,
    required this.challengeStructure,
    required this.puttingSets,
    required this.maxSets,
  }) : super(key: key);

  final GlobalKey<ScrollSnapListState> sslKey;
  final Function onUpdate;
  final bool isCurrentUser;
  final int itemCount;
  final int maxSets;

  final List<ChallengeStructureItem> challengeStructure;
  final List<PuttingSet> puttingSets;

  @override
  _ChallengeScrollSnapListState createState() =>
      _ChallengeScrollSnapListState();
}

class _ChallengeScrollSnapListState extends State<ChallengeScrollSnapList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ScrollSnapList(
      curve: Curves.easeOutBack,
      key: widget.sslKey,
      updateOnScroll: false,
      focusToItem: (index) {
        print('focusing to $index');
      },
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
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: ThemeColors.green,
              border: Border.all(color: Colors.grey[600]!, width: 1.5)),
          width: 60,
          height: 40,
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
      }
    }
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          border: Border.all(color: Colors.grey[600]!, width: 1.5)),
      width: 60,
      height: 40,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${widget.puttingSets[index].distance} ft',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
                '${widget.puttingSets[index].puttsMade} / ${widget.puttingSets[index].puttsAttempted}',
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
      required this.sslKey,
      required this.onUpdate,
      required this.itemCount})
      : super(key: key);

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
