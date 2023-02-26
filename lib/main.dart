import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myputt/cubits/app_phase_cubit.dart';
import 'package:myputt/cubits/events/event_detail_cubit.dart';
import 'package:myputt/cubits/events/event_standings_cubit.dart';
import 'package:myputt/cubits/search_user_cubit.dart';
import 'package:myputt/cubits/session_summary_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/screens/error/connection_error_screen.dart';
import 'package:myputt/screens/force_upgrade/force_upgrade_screen.dart';
import 'package:myputt/screens/introduction/intro_screen.dart';
import 'package:myputt/screens/auth/enter_details_screen.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/cubits/home_screen_cubit.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myputt/screens/wrappers/main_wrapper.dart';
import 'package:myputt/services/beta_access_service.dart';
import 'package:myputt/services/device_service.dart';
import 'package:myputt/services/dynamic_link_service.dart';
import 'package:myputt/theme/theme_data.dart';
import 'package:myputt/utils/hive_helpers.dart';
import 'cubits/my_profile_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final isPhysicalDevice = await DeviceService.isPhysicalDevice();
  FirebaseFirestore.instance.settings = const Settings(
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    persistenceEnabled: false,
  );
  if (kDebugMode && !isPhysicalDevice) {
    // FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  }
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  await initLocalDatabase();
  await setUpLocator();
  await locator.get<DynamicLinkService>().handleDynamicLinks();
  await locator.get<BetaAccessService>().loadFeatureAccess();
  await locator.get<AppPhaseCubit>().init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => HomeScreenCubit()),
            BlocProvider(create: (_) => SessionSummaryCubit()),
            BlocProvider(create: (_) => ChallengesCubit()),
            BlocProvider(create: (_) => MyProfileCubit()),
            BlocProvider(create: (_) => SearchUserCubit()),
            BlocProvider(create: (_) => EventDetailCubit()),
            BlocProvider(create: (_) => EventStandingsCubit()),
            BlocProvider(create: (_) => locator.get<AppPhaseCubit>()),
            BlocProvider(create: (_) => SessionsCubit()),
          ],
          child: const MyApp(),
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: BlocBuilder<AppPhaseCubit, AppPhaseState>(
        builder: (context, state) {
          return _getNewScreen(state);
        },
      ),
    );
  }

  Widget _getNewScreen(AppPhaseState state) {
    if (state is LoggedInPhase) {
      return const MainWrapper();
    } else if (state is LoggedOutPhase || state is FirstRunPhase) {
      return const IntroScreen();
    } else if (state is ForceUpgradePhase) {
      return const ForceUpgradeScreen();
    } else if (state is ConnectionErrorPhase) {
      return const ConnectionErrorScreen();
    } else {
      return const EnterDetailsScreen();
    }
  }
}
