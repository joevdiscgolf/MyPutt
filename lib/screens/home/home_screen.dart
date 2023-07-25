import 'package:flutter/material.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/home/components/home_app_bar.dart';
import 'package:myputt/screens/home/components/stats_view/stats_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/';
  static const String screenName = 'Home';

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    locator.get<Mixpanel>().track('Home Screen Impression');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: HomeAppBar(), body: StatsView());
  }
}
