import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

import 'package:myputt/data/types/users/frisbee_avatar.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/components/misc/frisbee_circle_icon.dart';

class EventItem extends StatelessWidget {
  const EventItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounceable(
        onTap: () {},
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
                color: MyPuttColors.gray[50],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 2),
                      color: MyPuttColors.gray[400]!,
                      blurRadius: 2)
                ]),
            child: Column(
              children: [],
            )));
  }
}
