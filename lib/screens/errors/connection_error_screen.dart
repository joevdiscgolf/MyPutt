import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/spinner_button.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/init_manager.dart';
import 'package:myputt/utils/colors.dart';

class ConnectionErrorScreen extends StatefulWidget {
  const ConnectionErrorScreen({Key? key}) : super(key: key);

  @override
  State<ConnectionErrorScreen> createState() => _ConnectionErrorScreenState();
}

class _ConnectionErrorScreenState extends State<ConnectionErrorScreen> {
  final InitManager _initManager = locator.get<InitManager>();

  bool _repeat = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MyPuttColors.blue,
              MyPuttColors.white,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  FlutterRemix.wifi_off_fill,
                  size: 80,
                ),
                const SizedBox(height: 20),
                Text(
                  "Oops!",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  "We experienced a connection issue, please try again",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SpinnerButton(
                  height: 48,
                  width: 120,
                  backgroundColor: MyPuttColors.blue,
                  textColor: MyPuttColors.white,
                  iconColor: MyPuttColors.white,
                  repeat: _repeat,
                  title: 'Retry',
                  onPressed: () async {
                    if (!mounted) return;
                    setState(() => _repeat = true);
                    await _initManager.init();
                    if (!mounted) return;
                    setState(() => _repeat = false);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
