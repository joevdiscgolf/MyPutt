import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myputt/controllers/screen_controller.dart';
import 'package:myputt/cubits/events/events_cubit.dart';
import 'package:myputt/cubits/search_user_cubit.dart';
import 'package:myputt/cubits/session_summary_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/screens/errors/connection_error_screen.dart';
import 'package:myputt/screens/introduction/intro_screen.dart';
import 'package:myputt/screens/errors/force_upgrade_screen.dart';
import 'package:myputt/screens/auth/enter_details_screen.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/cubits/home_screen_cubit.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myputt/screens/wrappers/main_wrapper.dart';
import 'package:myputt/services/beta_access_service.dart';
import 'package:myputt/services/dynamic_link_service.dart';
import 'package:myputt/services/init_manager.dart';
import 'package:myputt/theme/theme_data.dart';
import 'package:myputt/utils/enums.dart';
import 'cubits/my_profile_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings =
      const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  if (kDebugMode) {
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
    // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }
  await setUpLocator();
  await locator.get<DynamicLinkService>().handleDynamicLinks();
  await locator.get<InitManager>().init();
  await locator.get<BetaAccessService>().loadFeatureAccess();
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
        BlocProvider(create: (_) => MyProfileCubit()),
        BlocProvider(create: (_) => SearchUserCubit()),
        BlocProvider(create: (_) => EventsCubit())
      ],
      child: MaterialApp(
        builder: (context, child) {
          final mediaQueryData = MediaQuery.of(context);
          final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.0);
          return MediaQuery(
            child: child!,
            data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
          );
        },
        theme: lightTheme(context),
        title: 'MyPutt',
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<AppScreenState>(
            stream: locator.get<ScreenController>().appStateStream,
            builder: (context, snapshot) {
              if (snapshot.data == AppScreenState.loggedIn) {
                return const MainWrapper();
              } else if (snapshot.data == AppScreenState.notLoggedIn ||
                  snapshot.data == AppScreenState.firstRun) {
                return const IntroScreen();
              } else if (snapshot.data == AppScreenState.forceUpgrade) {
                return const ForceUpgradeScreen();
              } else if (snapshot.data == AppScreenState.connectionError) {
                return const ConnectionErrorScreen();
              } else {
                return const EnterDetailsScreen();
              }
            }),
      ),
    );
  }
}
