import 'package:flutter/material.dart';
import 'package:myputt/screens/wrappers/main_wrapper.dart';
import 'package:myputt/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MyPutt',
      debugShowCheckedModeBanner: false,
      home: MainWrapper(),
    );
  }
}
