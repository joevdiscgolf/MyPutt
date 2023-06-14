import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/protocols/myputt_cubit.dart';
import 'package:myputt/cubits/record/record_cubit_helpers.dart';
import 'package:myputt/models/data/conditions/condition_enums.dart';
import 'package:myputt/models/data/conditions/conditions.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

part 'record_state.dart';

class RecordCubit extends Cubit<RecordState> implements MyPuttCubit {
  @override
  void initCubit() {
    // TODO: implement init
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

  void openSession(PuttingSession session) {
    emit(
      RecordActive(
        distance: 20,
        setLength: 10,
        puttsSelected: 10,
        sslKey: GlobalKey<ScrollSnapListState>(),
        puttingConditions: const PuttingConditions(),
      ),
    );
  }

  void setExactDistance(int distance) {
    emit((state as RecordActive).copyWith(distance: distance));
  }

  void incrementDistance(bool increase) {
    final int newDistance = getNextDistancePreset(
      (state as RecordActive).distance,
      increase: increase,
    );

    emit((state as RecordActive).copyWith(distance: newDistance));
  }

  void incrementSetLength(bool increase) {
    emit(
      (state as RecordActive).copyWith(
        setLength:
            getUpdatedSetLength((state as RecordActive).setLength, increase),
      ),
    );
    _updatePuttsPickerIndex(increase);
  }

  void updatePuttsSelected(int puttsSelected) {
    if (puttsSelected != state.puttsSelected) {
      emit((state as RecordActive).copyWith(puttsSelected: puttsSelected));
    }
  }

  void updatePuttingStance(PuttingStance? updatedStance) {
    if (updatedStance !=
        (state as RecordActive).puttingConditions.puttingStance) {
      emit(
        (state as RecordActive).copyWith(
          puttingConditions: (state as RecordActive)
              .puttingConditions
              .copyWith({'puttingStance': updatedStance}),
        ),
      );
    }
  }

  void updateWindDirection(WindDirection? updatedWindDirection) {
    if (updatedWindDirection != state.puttingConditions.windDirection) {
      emit(
        (state as RecordActive).copyWith(
          puttingConditions: state.puttingConditions.copyWith({
            'windDirection': updatedWindDirection,
          }),
        ),
      );
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
