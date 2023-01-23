import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/screens/record/components/add_set_button.dart';
import 'package:myputt/screens/record/components/record_screen_app_bar.dart';
import 'package:myputt/screens/record/components/record_tab/quantity_row.dart';
import 'package:myputt/screens/record/components/record_tab/selection_tiles.dart';
import 'package:myputt/screens/record/components/stats_seciton.dart';
import 'package:myputt/utils/colors.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:myputt/components/misc/putts_made_picker.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  static String routeName = '/record_screen';

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final Mixpanel _mixpanel = locator.get<Mixpanel>();
  final UserRepository _userRepository = locator.get<UserRepository>();

  final GlobalKey<ScrollSnapListState> puttsMadePickerKey = GlobalKey();

  bool sessionInProgress = true;
  int _setLength = 10;
  int _focusedIndex = 10;
  late int _distance;

  @override
  void initState() {
    _distance = _userRepository
            .currentUser?.userSettings?.sessionSettings?.preferredDistance ??
        20;
    _setLength = _userRepository.currentUser?.userSettings?.sessionSettings
            ?.preferredPuttsPickerLength ??
        10;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyPuttColors.white,
      appBar: const RecordScreenAppBar(),
      body: _mainBody(context),
    );
  }

  Widget _mainBody(BuildContext context) {
    return BlocBuilder<SessionsCubit, SessionsState>(
      builder: (context, state) {
        if (state is SessionInProgressState) {
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              children: [
                const SelectionTilesRow(),
                const SizedBox(height: 40),
                const QuantityRow(),
                const SizedBox(height: 4),
                const SizedBox(height: 8),
                PuttsMadePicker(
                  length: _setLength,
                  initialIndex: _setLength.toDouble(),
                  challengeMode: false,
                  sslKey: puttsMadePickerKey,
                  onUpdate: (int newIndex) {
                    setState(() {
                      _focusedIndex = newIndex;
                    });
                  },
                ),
                const Expanded(child: StatsSection()),
                const AddSetButton(),
                // const SizedBox(height: 12),
                // const FinishSessionButton(),
                const SizedBox(height: 24),
              ],
            ),
          );
        } else {
          return Center(
            child: Center(
              child: EmptyState(
                onRetry: () =>
                    BlocProvider.of<SessionsCubit>(context).continueSession(),
              ),
            ),
          );
        }
      },
    );
  }
}
