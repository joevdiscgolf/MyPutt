import 'package:flutter/material.dart';

class ForceUpgradeScreen extends StatelessWidget {
  const ForceUpgradeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.headline3,
                  children: const [
                    TextSpan(
                      text: 'My',
                    ),
                    TextSpan(
                        text: 'Putt', style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
              Text(
                'is out of date. Please update the app.',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
