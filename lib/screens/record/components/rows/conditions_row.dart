import 'package:flutter/material.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/misc/circular_icon_container.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';

class ConditionsRow extends StatefulWidget {
  const ConditionsRow(
      {Key? key,
      required this.iconData,
      required this.onPressed,
      required this.label,
      required this.type,
      this.initialIndex = 0})
      : super(key: key);

  final IconData iconData;
  final Function onPressed;
  final String label;
  final ConditionsType type;
  final int initialIndex;

  @override
  State<ConditionsRow> createState() => _ConditionsRowState();
}

class _ConditionsRowState extends State<ConditionsRow> {
  late final List<dynamic> _conditionOptions;
  late int _index;

  @override
  void initState() {
    _index = widget.initialIndex;
    _conditionOptions = getConditionOptions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(color: MyPuttColors.gray[50], boxShadow: [
        BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 2,
            color: MyPuttColors.gray[400]!)
      ]),
      child: Row(
        children: [
          CircularIconContainer(
            icon: Icon(
              widget.iconData,
              color: MyPuttColors.blue,
              size: 32,
            ),
            size: 60,
            padding: 12,
          ),
          const SizedBox(width: 16),
          Text(
            widget.label,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontSize: 20, color: MyPuttColors.darkGray),
          ),
          const Spacer(),
          MyPuttButton(
            width: MediaQuery.of(context).size.width / 4,
            height: 40,
            title: getTitle(),
            textSize: 16,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            onPressed: () {
              if (_index < _conditionOptions.length - 1) {
                setState(() => _index++);
              } else {
                setState(() => _index = 0);
              }
              widget.onPressed(_conditionOptions[_index]);
            },
          )
        ],
      ),
    );
  }

  List<dynamic> getConditionOptions() {
    switch (widget.type) {
      case ConditionsType.wind:
        return windConditions;
      case ConditionsType.weather:
        return weatherConditions;
      default:
        return kDistanceOptions;
    }
  }

  String getTitle() {
    switch (widget.type) {
      case ConditionsType.wind:
        return windConditionsEnumMap[_conditionOptions[_index]]!;
      case ConditionsType.weather:
        return weatherConditionsEnumMap[_conditionOptions[_index]]!;
      default:
        return '${kDistanceOptions[_index].toString()} ft';
    }
  }
}
