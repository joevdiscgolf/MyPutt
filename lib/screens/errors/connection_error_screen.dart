import 'package:flutter/material.dart';
import 'package:myputt/components/buttons/spinner_button.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/init_service.dart';
import 'package:myputt/utils/colors.dart';

class ConnectionErrorScreen extends StatefulWidget {
  const ConnectionErrorScreen({Key? key}) : super(key: key);

  @override
  State<ConnectionErrorScreen> createState() => _ConnectionErrorScreenState();
}

class _ConnectionErrorScreenState extends State<ConnectionErrorScreen> {
  final InitService _initService = locator.get<InitService>();

  bool _repeat = true;

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
              const SizedBox(height: 16),
              Text(
                "Couldn't connect to the internet.\n\n Please try again.",
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SpinnerButton(
                  height: 48,
                  width: 120,
                  backgroundColor: MyPuttColors.gray[100]!,
                  repeat: _repeat,
                  title: 'Retry',
                  onPressed: () async {
                    if (!mounted) return;
                    setState(() => _repeat = true);
                    await _initService.init();
                    if (!mounted) return;
                    setState(() => _repeat = false);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
