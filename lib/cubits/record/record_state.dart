part of 'record_cubit.dart';

@immutable
abstract class RecordState {
  const RecordState({
    required this.distance,
    required this.setLength,
    required this.puttsSelected,
    required this.puttsPickerKey,
    required this.puttingConditions,
  });

  final int distance;
  final int setLength;
  final int puttsSelected;
  final GlobalKey<ScrollSnapListState> puttsPickerKey;
  final PuttingConditions puttingConditions;
}

class RecordActive extends RecordState {
  const RecordActive({
    required int distance,
    required int setLength,
    required int puttsSelected,
    required GlobalKey<ScrollSnapListState> sslKey,
    required PuttingConditions puttingConditions,
  }) : super(
          distance: distance,
          setLength: setLength,
          puttsSelected: puttsSelected,
          puttsPickerKey: sslKey,
          puttingConditions: puttingConditions,
        );

  RecordActive copyWith({
    int? distance,
    int? setLength,
    int? puttsSelected,
    GlobalKey<ScrollSnapListState>? puttsPickerKey,
    PuttingConditions? puttingConditions,
  }) {
    return RecordActive(
      distance: distance ?? this.distance,
      setLength: setLength ?? this.setLength,
      puttsSelected: puttsSelected ?? this.puttsSelected,
      sslKey: puttsPickerKey ?? this.puttsPickerKey,
      puttingConditions: puttingConditions ?? this.puttingConditions,
    );
  }
}
