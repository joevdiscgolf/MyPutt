import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:flutter/services.dart';

class PuttsMadePicker extends StatefulWidget {
  const PuttsMadePicker(
      {Key? key,
      this.initialIndex = 0,
      this.length = 10,
      required this.sslKey,
      required this.onUpdate,
      required this.challengeMode})
      : super(key: key);

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
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
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
            const maxDisplacement = 600;
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
    HapticFeedback.mediumImpact();
  }

  Widget _buildListItem(BuildContext context, int index) {
    Color? iconColor;
    Color backgroundColor;
    if (index == 0) {
      iconColor = focusedIndex == index ? Colors.red : Colors.grey[400]!;
      backgroundColor = Colors.transparent;
    } else {
      backgroundColor =
          index <= focusedIndex ? const Color(0xff00d162) : Colors.grey[200]!;
    }
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.grey[600]!)),
      width: 80,
      child: Center(
          child: index == 0
              ? Icon(
                  FlutterRemix.close_circle_line,
                  color: iconColor ?? Colors.white,
                  size: 40,
                )
              : Text((index).toString(),
                  style: TextStyle(
                      color:
                          index <= focusedIndex ? Colors.white : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold))),
    );
  }
}
