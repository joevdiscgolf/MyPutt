import 'package:flutter/material.dart';
import './components/percentage_column_view.dart';
import '../../data/types/putting_session.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static String routeName = '/';

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final circleOnePercentages = {10: 0.75, 15: 0.6, 20: 0.6, 25: 0.4, 30: 0.3};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.lightBlueAccent[200],
                title: const Text('MyPutt',
                    style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.bold))),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text('Your C1 stats',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(width: 20),
                  PercentageColumnView(percentages: circleOnePercentages),
                ],
              ),
            )));
  }
}
