import 'package:flutter/material.dart';
import 'package:myputt/locator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/repositories/sessions_repository.dart';
import 'package:myputt/screens/wrappers/main_wrapper.dart';
import 'package:myputt/bloc/cubits/sessions_cubit.dart';
import 'package:myputt/bloc/cubits/home_screen_cubit.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpLocator();
  await Firebase.initializeApp();

  await locator.get<SessionRepository>().fetchCurrentSession();
  await locator.get<SessionRepository>().fetchCompletedSessions();

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
        BlocProvider(create: (_) => HomeScreenCubit()),
      ],
      child: const MaterialApp(
        title: 'MyPutt',
        debugShowCheckedModeBanner: false,
        home: MainWrapper(),
      ),
    );
  }
}
