import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class CarouselHero extends StatelessWidget {
  const CarouselHero({
    Key? key,
    required this.assetPath,
    this.limitWidth = false,
  }) : super(key: key);

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
            padding: const EdgeInsets.only(top: 60),
            alignment: Alignment.bottomCenter,
            constraints:
                BoxConstraints(maxWidth: limitWidth ? 380 : double.infinity),
            child: Image(
              height: height,
              image: AssetImage(assetPath),
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Flexible(flex: 4, child: Center(child: _description(context))),
      ],
    );
  }

  Widget _description(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.headlineMedium,
              children: [
                TextSpan(
                    text: 'My',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: MyPuttColors.darkBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 40)),
                TextSpan(
                    text: 'Putt',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: MyPuttColors.darkGray,
                        fontWeight: FontWeight.w600,
                        fontSize: 40)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Master your game',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: MyPuttColors.gray[400]!,
                ),
          ),
        ],
      ),
    );
  }
}
