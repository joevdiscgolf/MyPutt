import 'package:flutter/widgets.dart';
import 'package:myputt/screens/home/home_screen.dart';
import 'package:myputt/screens/record/record_screen.dart';
import 'package:myputt/screens/sessions/sessions_screen.dart';

// All our routes will be available here
final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  HomeScreen.routeName: (BuildContext context) => const HomeScreen(),
  RecordScreen.routeName: (BuildContext context) => const RecordScreen(),
  SessionsScreen.routeName: (BuildContext context) => const SessionsScreen(),
};
