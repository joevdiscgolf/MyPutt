import 'package:flutter/material.dart';
import 'package:myputt/locator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/screens/wrappers/main_wrapper.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/bloc/cubits/sessions_cubit.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setUpLocator();
  await locator.get<DatabaseService>().startCurrentSession();
  await Future.delayed(const Duration(milliseconds: 100), () async {
    await locator.get<DatabaseService>().addCompletedSession();
  });
  await Future.delayed(const Duration(milliseconds: 100), () async {
    await locator.get<DatabaseService>().updateCurrentSession();
  });
  /*await Future.delayed(const Duration(milliseconds: 100), () async {
    await locator.get<DatabaseService>().deleteCurrentSession();
  });*/
  print(await locator.get<DatabaseService>().getCompletedSessions().then(
      (sessions) => sessions.map((session) => session!.dateStarted).toList()));
  print(await locator.get<DatabaseService>().getCurrentSession());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SessionsCubit()),
      ],
      child: const MaterialApp(
        title: 'MyPutt',
        debugShowCheckedModeBanner: false,
        home: MainWrapper(),
      ),
    );
  }
}
