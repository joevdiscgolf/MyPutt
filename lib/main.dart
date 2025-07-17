import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myputt/cubits/app_phase_cubit.dart';
import 'package:myputt/cubits/challenges/challenge_cubit_helper.dart';
import 'package:myputt/cubits/events/event_detail_cubit.dart';
import 'package:myputt/cubits/events/event_standings_cubit.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/cubits/record/record_cubit.dart';
import 'package:myputt/cubits/search_user_cubit.dart';
import 'package:myputt/cubits/session_summary_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/screens/error/connection_error_screen.dart';
import 'package:myputt/screens/force_upgrade/force_upgrade_screen.dart';
import 'package:myputt/screens/introduction/intro_screen.dart';
import 'package:myputt/screens/auth/enter_details_screen.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/cubits/home/home_screen_cubit.dart';
import 'package:myputt/cubits/challenges/challenges_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myputt/screens/wrappers/main_wrapper.dart';
import 'package:myputt/screens/wrappers/toast_layer.dart';
import 'package:myputt/services/beta_access_service.dart';
import 'package:myputt/services/challenges_service.dart';
import 'package:myputt/services/device_service.dart';
import 'package:myputt/services/dynamic_link_service.dart';
import 'package:myputt/services/global_settings.dart';
import 'package:myputt/theme/theme_data.dart';
import 'package:myputt/utils/hive_helpers.dart';
import 'package:myputt/utils/utils.dart';
import 'cubits/my_profile_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final isPhysicalDevice = await DeviceService.isPhysicalDevice();
  FirebaseFirestore.instance.settings = const Settings(
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    persistenceEnabled: GlobalSettings.useFirebaseCache,
  );
  if (kDebugMode && !isPhysicalDevice) {
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  }
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  await initLocalDatabase();
  await setUpLocator();
  await locator.get<DynamicLinkService>().handleDynamicLinks();
  await locator.get<BetaAccessService>().loadFeatureAccess();

  initAllSingletons([
    locator.get<AppPhaseCubit>(),
    locator.get<HomeScreenV2Cubit>(),
    locator.get<SessionsCubit>(),
    locator.get<ChallengesCubit>(),
    locator.get<ChallengesCubitHelper>(),
    locator.get<ChallengesService>()
  ]);
  initMyPuttCubits([
    locator.get<HomeScreenV2Cubit>(),
    locator.get<SessionsCubit>(),
    locator.get<ChallengesCubit>(),
  ]);
  await locator.get<AppPhaseCubit>().initCubit();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => HomeScreenCubit()),
            BlocProvider(create: (_) => locator.get<HomeScreenV2Cubit>()),
            BlocProvider(create: (_) => SessionSummaryCubit()),
            BlocProvider(create: (_) => locator.get<ChallengesCubit>()),
            BlocProvider(create: (_) => MyProfileCubit()),
            BlocProvider(create: (_) => SearchUserCubit()),
            BlocProvider(create: (_) => EventDetailCubit()),
            BlocProvider(create: (_) => EventStandingsCubit()),
            BlocProvider(create: (_) => locator.get<AppPhaseCubit>()),
            BlocProvider(create: (_) => locator.get<SessionsCubit>()),
            BlocProvider(create: (_) => RecordCubit()),
          ],
          child: const MyApp(),
        ),
      );
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Connectivity().onConnectivityChanged.listen((results) {
      _connectivityListener(results);
    });
    _initTimer();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final scale = mediaQueryData.textScaler.clamp(
          maxScaleFactor: 1.0,
          minScaleFactor: 1.0,
        );
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: scale),
          child: child ?? const SizedBox(),
        );
      },
      theme: lightTheme(context),
      title: 'MyPutt',
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          BlocBuilder<AppPhaseCubit, AppPhaseState>(
            builder: (context, state) {
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
            },
          ),
          const ToastLayer(),
        ],
      ),
    );
  }

  List<ConnectivityResult>? _connectivityResults;

  void _connectivityListener(List<ConnectivityResult> results) {
    final bool wasConnected = _connectivityResults != null && hasConnectivityFromList(_connectivityResults!);
    final bool isConnected = hasConnectivityFromList(results);
    
    if (_connectivityResults == null || (!wasConnected && isConnected)) {
      _onConnected();
    }
    _connectivityResults = results;
  }

  void _initTimer() {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (_connectivityResults != null &&
          hasConnectivityFromList(_connectivityResults!)) {
        await locator.get<SessionsRepository>().syncAllLocalSessionsToCloud();
        await locator.get<ChallengesRepository>().syncLocalChallengesToCloud();
      }
    });
  }

  Future<void> _onConnected() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    BlocProvider.of<SessionsCubit>(context).onConnectionEstablished();
    BlocProvider.of<ChallengesCubit>(context).onConnectionEstablished();
  }
}
