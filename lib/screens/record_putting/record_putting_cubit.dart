import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'record_putting_state.dart';

class RecordPuttingCubit extends Cubit<RecordPuttingState> {
  RecordPuttingCubit() : super(RecordPuttingInitial());
}
