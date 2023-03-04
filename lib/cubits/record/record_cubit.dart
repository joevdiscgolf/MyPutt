import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:myputt/cubits/record/record_cubit_helpers.dart';
import 'package:myputt/models/data/conditions/condition_enums.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

part 'record_state.dart';

class RecordCubit extends Cubit<RecordState> {
  RecordCubit() : super(const RecordInitial());

  void openRecordScreen() {
    emit(
      RecordActive(
        distance: 20,
        setLength: 10,
        puttsSelected: 10,
        sslKey: GlobalKey<ScrollSnapListState>(),
      ),
    );
  }

  void updateDistance(int distance) {
    if (state is! RecordActive) return;
    emit((state as RecordActive).copyWith(distance: distance));
  }

  void incrementDistance(bool increase) {
    if (state is! RecordActive) return;

    final int newDistance = getNextDistancePreset(
      (state as RecordActive).distance,
      increase: increase,
    );

    emit((state as RecordActive).copyWith(distance: newDistance));
  }

  void updateSetLength(int setLength) {
    if (state is! RecordActive) return;
    emit((state as RecordActive).copyWith(setLength: setLength));
  }

  void updatePuttsSelected(int puttsSelected) {
    if (state is! RecordActive) return;
    emit((state as RecordActive).copyWith(puttsSelected: puttsSelected));
  }

  void closeRecordScreen() {
    emit(const RecordInitial());
  }
}
