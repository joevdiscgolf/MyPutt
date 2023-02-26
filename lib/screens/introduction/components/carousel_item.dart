import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class CarouselItem extends StatelessWidget {
  const CarouselItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.assetPath,
    this.limitWidth = false,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String assetPath;
  final bool limitWidth;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          flex: 9,
          child: Container(
            // color: Colors.white,
            padding: const EdgeInsets.only(top: 60),
            alignment: Alignment.bottomCenter,
            constraints:
                BoxConstraints(maxWidth: limitWidth ? 380 : double.infinity),
            child: Image(
              height: height / 2,
              image: AssetImage(assetPath),
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
            ),
          ),
        ),
        Flexible(flex: 4, child: Center(child: _description(context))),
      ],
    );
  }

  Widget _description(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 24, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: MyPuttColors.gray[600],
                ),
          ),
        ],
      ),
    );
  }
}
