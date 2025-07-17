import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/putting_preferences/putting_preferences.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/protocols/myputt_cubit.dart';
import 'package:myputt/cubits/record/record_cubit_helpers.dart';
import 'package:myputt/models/data/conditions/condition_enums.dart';
import 'package:myputt/models/data/conditions/conditions.dart';
import 'package:myputt/repositories/putting_preferences_repository.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

part 'record_state.dart';

class RecordCubit extends Cubit<RecordState> implements MyPuttCubit {
  @override
  void initCubit() {
    // todo: implement init
  }
  RecordCubit()
      : super(
          RecordActive(
            distance: 20,
            setLength: 10,
            puttsSelected: 10,
            sslKey: GlobalKey<ScrollSnapListState>(),
            puttingConditions: const PuttingConditions(),
          ),
        );

  final PuttingPreferencesRepository _preferencesRepository =
      locator.get<PuttingPreferencesRepository>();

  void openSession(PuttingSession session) {
    final PuttingPreferences puttingPreferences =
        _preferencesRepository.puttingPreferences;

    emit(
      RecordActive(
        distance: puttingPreferences.preferredDistance,
        setLength: puttingPreferences.preferredSetLength,
        puttsSelected: puttingPreferences.preferredSetLength,
        sslKey: GlobalKey<ScrollSnapListState>(),
        puttingConditions: puttingPreferences.puttingConditions,
      ),
    );
  }

  void setExactDistance(int exactDistance) {
    if (state is! RecordActive) return;
    final RecordActive activeState = state as RecordActive;

    emit(activeState.copyWith(distance: exactDistance));

    _preferencesRepository.preferredDistance = exactDistance;
  }

  void incrementDistance(bool increase) {
    if (state is! RecordActive) return;
    final RecordActive activeState = state as RecordActive;

    final int newDistance = getNextDistancePreset(
      activeState.distance,
      increase: increase,
    );

    emit(activeState.copyWith(distance: newDistance));

    _preferencesRepository.preferredDistance = newDistance;
  }

  void incrementSetLength(bool increase) {
    if (state is! RecordActive) return;
    final RecordActive activeState = state as RecordActive;

    final int updatedSetLength =
        getUpdatedSetLength(activeState.setLength, increase);

    emit(
      activeState.copyWith(setLength: updatedSetLength),
    );
    _updatePuttsPickerIndex(increase);

    _preferencesRepository.preferredSetLength = updatedSetLength;
  }

  void updatePuttsSelected(int puttsSelected) {
    if (state is! RecordActive) return;
    final RecordActive activeState = state as RecordActive;

    if (puttsSelected != state.puttsSelected) {
      emit(activeState.copyWith(puttsSelected: puttsSelected));
    }
  }

  void updatePuttingStance(PuttingStance? updatedStance) {
    if (state is! RecordActive) return;
    final RecordActive activeState = state as RecordActive;

    if (updatedStance != activeState.puttingConditions.puttingStance) {
      final PuttingConditions updatedConditions = activeState.puttingConditions
          .copyWith({'puttingStance': updatedStance});

      emit(
        activeState.copyWith(puttingConditions: updatedConditions),
      );

      _preferencesRepository.puttingConditions = updatedConditions;
    }
  }

  void updateWindDirection(WindDirection? updatedWindDirection) {
    if (state is! RecordActive) return;
    final RecordActive activeState = state as RecordActive;

    if (updatedWindDirection != state.puttingConditions.windDirection) {
      final PuttingConditions updatedConditions =
          activeState.puttingConditions.copyWith({
        'windDirection': updatedWindDirection,
      });

      emit(activeState.copyWith(puttingConditions: updatedConditions));

      _preferencesRepository.puttingConditions = updatedConditions;
    }
  }

  Future<void> _updatePuttsPickerIndex(bool increase) async {
    if (increase) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    late final int newFocusedIndex;

    if (increase) {
      newFocusedIndex = state.setLength + 1;
    } else {
      newFocusedIndex = state.setLength;
    }
    state.puttsPickerKey.currentState?.focusToItem(newFocusedIndex);
  }
}
