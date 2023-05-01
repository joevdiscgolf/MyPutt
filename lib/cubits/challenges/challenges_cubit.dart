import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:myputt/cubits/challenges/challenge_cubit_helper.dart';
import 'package:myputt/protocols/myputt_cubit.dart';
import 'package:myputt/models/data/challenges/challenge_structure_item.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/models/data/challenges/storage_putting_challenge.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/protocols/singleton_consumer.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/presets_repository.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/services/dynamic_link_service.dart';
import 'package:myputt/services/toast/toast_service.dart';
import 'package:myputt/utils/challenge_helpers.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/utils/constants.dart';

part 'challenges_state.dart';

class ChallengesCubit extends Cubit<ChallengesState>
    with MyPuttCubit
    implements SingletonConsumer {
  ChallengesCubit()
      : super(
          ChallengesLoading(
            completedChallenges: [],
            activeChallenges: [],
            currentChallenge: null,
            pendingChallenges: [],
          ),
        );

  @override
  void initSingletons() {
    _challengesRepository = locator.get<ChallengesRepository>();
    _userRepository = locator.get<UserRepository>();
    _dynamicLinkService = locator.get<DynamicLinkService>();
    _presetsRepository = locator.get<PresetsRepository>();
    _challengesCubitHelper = locator.get<ChallengesCubitHelper>();
    _toastService = locator.get<ToastService>();
  }

  @override
  void initCubit() {
    _challengesRepository.addListener(() {
      if (_challengesRepository.currentChallenge != null) {
        final ChallengesState newState = _challengesCubitHelper
            .getStateFromChallenge(_challengesRepository.currentChallenge!);

        emit(newState);

        if (newState is CurrentChallengeState &&
            newState.challengeStage == ChallengeStage.finished) {
          _challengesRepository.moveCurrentChallengeToFinished();
        }
      } else {
        emit(
          NoCurrentChallengeState(
            activeChallenges: _challengesRepository.activeChallenges,
            pendingChallenges: _challengesRepository.incomingPendingChallenges,
            completedChallenges: _challengesRepository.completedChallenges,
          ),
        );
      }
    });
  }

  late final ChallengesRepository _challengesRepository;
  late final UserRepository _userRepository;
  late final DynamicLinkService _dynamicLinkService;
  late final PresetsRepository _presetsRepository;
  late final ChallengesCubitHelper _challengesCubitHelper;
  late final ToastService _toastService;

  Future<void> reload() async {
    await _challengesRepository.fetchCloudChallenges();
    if (_challengesRepository.currentChallenge != null) {
      emit(
        _challengesCubitHelper
            .getStateFromChallenge(_challengesRepository.currentChallenge!),
      );
    } else {
      emit(_challengesCubitHelper.noCurrentChallenge());
    }
  }

  void openChallenge(PuttingChallenge challenge) {
    _challengesRepository.openChallenge(challenge);
  }

  void closeChallenge() {
    _challengesRepository.exitCurrentChallenge();
  }

  Future<void> addSet(PuttingSet set) async {
    if (_challengesRepository.currentChallenge == null) return;

    if (!ChallengeHelpers.currentUserSetsComplete(
      _challengesRepository.currentChallenge!,
    )) {
      _challengesRepository.addSet(set);
    }
  }

  Future<void> undo() async {
    final List<PuttingSet>? currentUserSets =
        _challengesRepository.currentChallenge?.currentUserSets;
    if (currentUserSets != null && currentUserSets.isNotEmpty) {
      _challengesRepository.deleteSet(currentUserSets.last);
    }
  }

  Future<void> finishChallenge() async {
    if (_challengesRepository.currentChallenge == null) return;

    final bool finishSuccess = await _challengesRepository.finishChallenge();

    if (!finishSuccess) {
      _toastService.triggerErrorToast("Couldn't finish challenge, try again.");
    } else {
      emit(
        _challengesCubitHelper.currentChallengeWithStage(
          ChallengeStage.finished,
        ),
      );
    }
  }

  void deleteChallenge(PuttingChallenge challenge) {
    _challengesRepository.deleteChallenge(challenge);
  }

  void declineChallenge(PuttingChallenge challenge) {
    _challengesRepository.declineChallenge(challenge);
    if (state is CurrentChallengeState) {
      emit(
        _challengesCubitHelper.currentChallengeWithStage(
            (state as CurrentChallengeState).challengeStage),
      );
    } else {
      emit(_challengesCubitHelper.noCurrentChallenge());
    }
  }

  Future<bool> sendChallengeFromSession(
    PuttingSession session,
    MyPuttUser recipientUser,
  ) async {
    MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      await _userRepository.fetchCloudCurrentUser(timeoutDuration: tinyTimeout);
      currentUser = _userRepository.currentUser;
    }

    if (currentUser == null) {
      _toastService.triggerErrorToast("Couldn't send challenge, try again.");
      return false;
    }

    final PuttingChallenge challengeFromSession = PuttingChallenge.fromSession(
      session,
      currentUser,
      opponentUser: recipientUser,
    );

    final bool sendSuccess = await _challengesRepository.sendChallenge(
      challengeFromSession,
      currentUser.uid,
    );

    if (!sendSuccess) {
      _toastService.triggerErrorToast("Couldn't send challenge, try again.");
    }
    return sendSuccess;
  }

  Future<bool> sendChallengeWithPreset(
    ChallengePreset challengePreset,
    MyPuttUser recipientUser,
  ) async {
    MyPuttUser? currentUser = _userRepository.currentUser;

    if (currentUser == null) {
      await _userRepository.fetchCloudCurrentUser();
      currentUser = _userRepository.currentUser;
    }

    if (currentUser == null) {
      _toastService.triggerErrorToast("Couldn't send challenge, try again.");
      return false;
    }

    final PuttingChallenge challenge = ChallengeHelpers.getChallengeFromPreset(
      challengePreset,
      currentUser,
      recipientUser,
    );

    final bool sendSuccess = await _challengesRepository.sendChallenge(
      challenge,
      currentUser.uid,
    );

    if (!sendSuccess) {
      _toastService.triggerErrorToast("Couldn't send challenge, try again.");
    }
    return sendSuccess;
  }

  Future<String?> getShareMessageFromSession(PuttingSession session) async {
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return null;
    }
    final StoragePuttingChallenge newChallenge =
        StoragePuttingChallenge.fromSession(session, currentUser);
    await locator.get<DatabaseService>().setUnclaimedChallenge(newChallenge);
    final Uri uri =
        await _dynamicLinkService.generateDynamicLinkFromId(newChallenge.id);
    return '${currentUser.displayName} is challenging you to a putting competition! $uri';
  }

  Future<String?> getShareMessageFromPreset(ChallengePreset preset) async {
    final List<ChallengeStructureItem>? challengeStructure =
        _presetsRepository.presetStructures[preset];
    if (challengeStructure == null) {
      return null;
    }
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return null;
    }
    final int timeStamp = DateTime.now().millisecondsSinceEpoch;
    final StoragePuttingChallenge newChallenge = StoragePuttingChallenge(
        status: ChallengeStatus.pending,
        creationTimeStamp: timeStamp,
        id: '${currentUser.uid}~$timeStamp',
        challengerUser: currentUser,
        challengeStructure: challengeStructure,
        challengerSets: [],
        recipientSets: []);
    await locator.get<DatabaseService>().setUnclaimedChallenge(newChallenge);
    final Uri uri =
        await _dynamicLinkService.generateDynamicLinkFromId(newChallenge.id);
    return '${currentUser.displayName} is challenging you to a putting competition! $uri';
  }

  int getPuttsPickerIndex() {
    if (state is! CurrentChallengeState) {
      return 0;
    }
    final CurrentChallengeState currentChallengeState =
        state as CurrentChallengeState;

    return currentChallengeState
        .currentChallenge
        .challengeStructure[
            currentChallengeState.currentChallenge.currentUserSets.length -
                (ChallengeHelpers.currentUserSetsComplete(
                  currentChallengeState.currentChallenge,
                )
                    ? 1
                    : 0)]
        .setLength;
  }

  Future<void> onConnectionEstablished() async {
    await locator.get<ChallengesRepository>().fetchCloudChallenges();
    await locator.get<ChallengesRepository>().syncLocalChallengesToCloud();
  }
}
