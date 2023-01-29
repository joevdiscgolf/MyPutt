part of 'app_phase_cubit.dart';

@immutable
abstract class AppPhaseState {
  const AppPhaseState() : super();
}

class AppPhaseInitial extends AppPhaseState {
  const AppPhaseInitial() : super();
}

class LoggedInPhase extends AppPhaseState {
  const LoggedInPhase() : super();
}

class LoggedOutPhase extends AppPhaseState {
  const LoggedOutPhase() : super();
}

class SetUpPhase extends AppPhaseState {
  const SetUpPhase() : super();
}

class FirstRunPhase extends AppPhaseState {
  const FirstRunPhase() : super();
}

class ForceUpgradePhase extends AppPhaseState {
  const ForceUpgradePhase() : super();
}

class ConnectionErrorPhase extends AppPhaseState {
  const ConnectionErrorPhase() : super();
}
