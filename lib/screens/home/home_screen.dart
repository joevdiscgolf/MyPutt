import 'package:flutter/material.dart';
import './components/percentages_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static String routeName = '/';

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final circleOnePercentages = {10: 0.75, 15: 0.6, 20: 0.6, 25: 0.4, 30: 0.3};
  final cirlceTwoPercentages = {40: 0.4, 50: 0.2, 60: 0.15};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.grey[100]!,
            appBar: AppBar(
                backgroundColor: Colors.lightBlueAccent[200],
                title: const Text('MyPutt',
                    style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.bold))),
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Text('Circle 1',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              Text('Circle 2',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  PercentagesCard(
                                      percentages: circleOnePercentages),
                                ],
                              ),
                              Column(
                                children: [
                                  PercentagesCard(
                                      percentages: cirlceTwoPercentages),
                                ],
                              )
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            )));
  }
}
