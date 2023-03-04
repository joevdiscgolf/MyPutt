import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/utils/colors.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class PuttsMadePicker extends StatefulWidget {
  const PuttsMadePicker({
    Key? key,
    this.initialIndex = 0,
    this.length = 10,
    required this.sslKey,
    required this.onUpdate,
    required this.challengeMode,
  }) : super(key: key);

  final double initialIndex;
  final int length;
  final GlobalKey<ScrollSnapListState> sslKey;
  final Function onUpdate;
  final bool challengeMode;

  @override
  _PuttsMadePickerState createState() => _PuttsMadePickerState();
}

class _PuttsMadePickerState extends State<PuttsMadePicker> {
  late int focusedIndex;

  @override
  void initState() {
    focusedIndex = widget.initialIndex.toInt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 124,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ScrollSnapList(
          initialIndex: widget.initialIndex,
          key: widget.sslKey,
          updateOnScroll: true,
          focusToItem: (index) {},
          itemSize: 80,
          itemCount: widget.length + 1,
          duration: 125,
          focusOnItemTap: true,
          onItemFocus: _onItemFocus,
          itemBuilder: _buildListItem,
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
          }, // dynamicSizeEquation: customEquation, //optional
        ));
  }

  void _onItemFocus(int index) {
    setState(() {
      focusedIndex = index;
    });
    widget.onUpdate(index);
    Vibrate.feedback(FeedbackType.medium);
  }

  Widget _buildListItem(BuildContext context, int index) {
    return Builder(builder: (context) {
      Color? iconColor;
      Color backgroundColor;
      if (index == 0) {
        iconColor = focusedIndex == index ? Colors.red : Colors.grey[400]!;
        backgroundColor =
            focusedIndex == index ? MyPuttColors.gray[50]! : MyPuttColors.white;
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              border: Border.all(
                width: 4,
                color: MyPuttColors.gray[100]!,
              )),
          child: Icon(
            FlutterRemix.close_circle_line,
            color: iconColor,
            size: 40,
          ),
        );
      } else {
        backgroundColor = index <= focusedIndex
            ? MyPuttColors.white
            : MyPuttColors.gray[200]!;
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: 2,
                    color: MyPuttColors.gray[300]!)
              ],
              color: backgroundColor,
              shape: BoxShape.circle,
              border: Border.all(
                width: 4,
                color: MyPuttColors.lightBlue,
              )),
          child: Center(
              child: Text((index).toString(),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 20, color: MyPuttColors.darkGray))),
        );
      }
    });
  }
}
