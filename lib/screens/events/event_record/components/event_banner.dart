import 'package:flutter/material.dart';
import 'package:myputt/data/types/events/myputt_event.dart';
import 'package:myputt/utils/constants.dart';

class EventBanner extends StatelessWidget {
  const EventBanner({Key? key, required this.event}) : super(key: key);

  final MyPuttEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        image: event.bannerImgUrl != null
            ? DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.srcOver),
                image: NetworkImage(event.bannerImgUrl!))
            : DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.srcOver),
                image: const AssetImage(defaultEventImgPath)),
      ),
    );
  }
}
