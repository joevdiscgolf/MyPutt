import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/session_repository.dart';

part 'home_screen_v2_state.dart';

class HomeScreenV2Cubit extends Cubit<HomeScreenV2State> {
  HomeScreenV2Cubit() : super(HomeScreenV2Initial()) {
    init();
  }

  late final StreamSubscription<SessionRepository>
      sessionRepositorySubscription;

  init() {
    locator.get<SessionRepository>().addListener(() {
      print('session repository changed triggered');
    });
    locator.get<ChallengesRepository>().addListener(() {
      print('challenges repository changed');
    });
  }
}
