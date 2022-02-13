import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:flutter/services.dart';

class PuttsMadePicker extends StatefulWidget {
  PuttsMadePicker(
      {Key? key,
      required this.sslKey,
      required this.onUpdate,
      required this.challengeMode})
      : super(key: key);

  final GlobalKey<ScrollSnapListState> sslKey;
  final Function onUpdate;
  final bool challengeMode;

  final _PuttsMadePickerState thisState = _PuttsMadePickerState();

  @override
  _PuttsMadePickerState createState() => thisState;

  void adjustSetLength(bool incremented) {
    thisState.adjustSetLength(incremented);
  }
}

class _PuttsMadePickerState extends State<PuttsMadePicker> {
  int focusedIndex = 0;
  int setLength = 10;

  @override
  Widget build(BuildContext context) {
    if (widget.challengeMode) {
      return BlocBuilder<ChallengesCubit, ChallengesState>(
        builder: (context, state) {
          if (state is ChallengeInProgress) {
            final int index = state.currentChallenge.currentUserSets.length ==
                    state.currentChallenge.opponentSets.length
                ? state.currentChallenge.currentUserSets.length - 1
                : state.currentChallenge.currentUserSets.length;
            final int newSetLength = state
                .currentChallenge.opponentSets[index].puttsAttempted as int;
            return Container(
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: ScrollSnapList(
                  key: widget.sslKey,
                  updateOnScroll: true,
                  focusToItem: (index) {},
                  itemSize: 80,
                  itemCount: newSetLength + 1,
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
          } else if (state is ChallengeComplete) {
            final int newSetLength = state
                .currentChallenge
                .opponentSets[state.currentChallenge.currentUserSets.length - 1]
                .puttsAttempted as int;
            return Container(
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: ScrollSnapList(
                  key: widget.sslKey,
                  updateOnScroll: true,
                  focusToItem: (index) {},
                  itemSize: 80,
                  itemCount: newSetLength + 1,
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
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
    } else {
      return Container(
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: ScrollSnapList(
            key: widget.sslKey,
            updateOnScroll: true,
            focusToItem: (index) {},
            itemSize: 80,
            itemCount: setLength + 1,
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
  }

  void adjustSetLength(bool incremented) {
    setState(() {
      if (incremented) {
        setLength += 1;
      } else {
        if (setLength > 1) {
          setLength -= 1;
        }
      }
    });
    if (!incremented) {
      if (setLength == (focusedIndex) && focusedIndex != 1) {
        setState(() {
          focusedIndex -= 1;
        });
      }
      widget.sslKey.currentState?.focusToItem(focusedIndex - 1);
    }
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
