import 'package:flutter/material.dart';
import 'package:myputt/locator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/repositories/sessions_repository.dart';
import 'package:myputt/screens/wrappers/main_wrapper.dart';
import 'package:myputt/screens/auth/landing_screen.dart';
import 'package:myputt/bloc/cubits/sessions_cubit.dart';
import 'package:myputt/bloc/cubits/home_screen_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/services/signin_service.dart';
import 'package:myputt/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setUpLocator();

  if (locator.get<AuthService>().getCurrentUserId() != null) {
    await locator.get<SessionRepository>().fetchCurrentSession();
    await locator.get<SessionRepository>().fetchCompletedSessions();
  }

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
      child: MaterialApp(
        title: 'MyPutt',
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<bool>(
            stream: locator.get<SigninService>().siginStream,
            builder: (context, snapshot) {
              print('event added: $snapshot');
              if (snapshot.data == true) {
                return const MainWrapper();
              } else {
                return const LandingScreen();
              }
            }),
      ),
    );
  }
}
