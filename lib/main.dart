import 'package:flutter/material.dart';
import 'package:myputt/cubits/session_summary_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/screens/wrappers/main_wrapper.dart';
import 'package:myputt/screens/auth/landing_screen.dart';
import 'package:myputt/screens/auth/enter_details_screen.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/cubits/home_screen_cubit.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/services/dynamic_link_service.dart';
import 'package:myputt/services/signin_service.dart';
import 'package:myputt/utils/utils.dart';
import 'package:myputt/theme/theme_data.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/services/web_scraper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setUpLocator();
  locator.get<DynamicLinkService>().handleDynamicLinks();
  await locator.get<SigninService>().init();

  /*if (locator.get<AuthService>().getCurrentUserId() != null) {
    await fetchRepositoryData();
  }*/
  locator.get<ChallengesRepository>().getTestChallenge();
  //locator.get<WebScraperService>().getPDGAData(132408);

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
        BlocProvider(create: (_) => SessionSummaryCubit()),
        BlocProvider(create: (_) => ChallengesCubit()),
      ],
      child: MaterialApp(
        theme: lightTheme(context),
        title: 'MyPutt',
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<LoginState>(
            stream: locator.get<SigninService>().siginStream,
            builder: (context, snapshot) {
              if (snapshot.data == LoginState.loggedIn) {
                return const MainWrapper();
              } else if (snapshot.data == LoginState.none) {
                return const LandingScreen();
              } else {
                return const EnterDetailsScreen();
              }
            }),
      ),
    );
  }
}
