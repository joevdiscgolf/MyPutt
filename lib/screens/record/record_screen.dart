import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/components/buttons/app_bar_back_button.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/dialogs/confirm_dialog.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/components/misc/shadow_icon.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:myputt/screens/record/components/rows/putting_set_row.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/components/misc/putts_made_picker.dart';
import 'components/rows/conditions_row.dart';

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
      appBar: AppBar(
        iconTheme: const IconThemeData(color: MyPuttColors.darkGray),
        centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: const AppBarBackButton(),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: MyPuttButton(
              backgroundColor: Colors.transparent,
              textColor: MyPuttColors.darkGray,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (dialogContext) => ConfirmDialog(
                          title: 'Finish session',
                          icon: const ShadowIcon(
                            icon: Icon(
                              FlutterRemix.medal_2_fill,
                              size: 80,
                              color: MyPuttColors.black,
                            ),
                          ),
                          buttonlabel: 'Finish',
                          buttonColor: MyPuttColors.blue,
                          actionPressed: () {
                            _mixpanel.track(
                              'Record Screen Finish Session Confirmed',
                            );
                            BlocProvider.of<SessionsCubit>(context)
                                .completeSession();
                            setState(() {
                              sessionInProgress = false;
                            });
                          },
                        )).then((value) => dialogCallBack());
              },
              title: 'Finish',
              iconColor: MyPuttColors.darkGray,
            ),
          ),
        ],
        title: Text('Record',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontSize: 28, color: MyPuttColors.blue)),
      ),
      body: _mainBody(context),
    );
  }

  Widget _mainBody(BuildContext context) {
    return BlocBuilder<SessionsCubit, SessionsState>(
      builder: (context, state) {
        if (state is SessionInProgressState) {
          List<Widget> previousSetsChildren =
              List.from(state.currentSession.sets
                  .asMap()
                  .entries
                  .map(
                    (entry) => PuttingSetRow(
                      deletable: true,
                      set: entry.value,
                      index: entry.key,
                      delete: () {
                        _mixpanel.track('Record Screen Set Deleted');
                        BlocProvider.of<SessionsCubit>(context)
                            .deleteSet(entry.value);
                      },
                    ),
                  )
                  .toList()
                  .reversed);
          return ListView(
            children: [
              _detailsPanel(context),
              const SizedBox(height: 16),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Putts made',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                    color: MyPuttColors.darkGray,
                                    fontSize: 20)),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _putterCountPicker(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  PuttsMadePicker(
                      length: _setLength,
                      initialIndex: _setLength.toDouble(),
                      challengeMode: false,
                      sslKey: puttsMadePickerKey,
                      onUpdate: (int newIndex) {
                        setState(() {
                          _focusedIndex = newIndex;
                        });
                      }),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: MyPuttButton(
                    title: 'Add set',
                    width: MediaQuery.of(context).size.width / 2,
                    height: 50,
                    iconData: FlutterRemix.add_line,
                    onPressed: () {
                      _mixpanel.track(
                        'Record Screen Add Set Button Pressed',
                        properties: {
                          'Putts Attempted': _setLength,
                          'Putts Made': _focusedIndex
                        },
                      );
                      BlocProvider.of<SessionsCubit>(context).addSet(
                        PuttingSet(
                          timeStamp: DateTime.now().millisecondsSinceEpoch,
                          puttsMade: _focusedIndex,
                          puttsAttempted: _setLength,
                          distance: _distance,
                        ),
                      );
                    }),
              ),
              const SizedBox(height: 10),
              ...previousSetsChildren,
            ],
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

  Widget _detailsPanel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Details',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontSize: 20, color: MyPuttColors.darkGray),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        // ConditionsRow(
        //   onPressed: (WindCondition wind) =>
        //       setState(() => _windCondition = wind),
        //   iconData: FlutterRemix.windy_line,
        //   label: 'Wind',
        //   type: ConditionsType.wind,
        // ),
        // ConditionsRow(
        //   onPressed: (WeatherCondition weather) =>
        //       setState(() => _weatherCondition = weather),
        //   iconData: FlutterRemix.sun_fill,
        //   label: 'Weather',
        //   type: ConditionsType.weather,
        // ),
        ConditionsRow(
          initialIndex: distanceToIndex[_distance]!,
          onPressed: (int dist) {
            _mixpanel.track(
              'Record Screen Change Distance Button Pressed',
              properties: {'Distance': dist},
            );
            setState(() => _distance = dist);
          },
          iconData: FlutterRemix.map_pin_2_line,
          label: 'Distance',
          type: ConditionsType.distance,
        ),
      ],
    );
  }

  Widget _putterCountPicker(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              child: Text(
                '-',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 32, color: MyPuttColors.darkGray),
              ),
              onPressed: () {
                puttsMadePickerKey.currentState?.focusToItem(_setLength - 2);
                if (_setLength > 1) {
                  setState(() {
                    _setLength -= 1;
                    _focusedIndex = _setLength;
                  });
                }
                _mixpanel.track(
                  'Record Screen Putter Count Changed',
                  properties: {'Set Length': _setLength},
                );
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.transparent, shadowColor: Colors.transparent),
            ),
            const SizedBox(width: 5),
            Text(
              _setLength.toString(),
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontSize: 16, color: MyPuttColors.darkGray),
            ),
            const SizedBox(width: 5),
            ElevatedButton(
              child: Text(
                '+',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 32, color: MyPuttColors.darkGray),
              ),
              onPressed: () {
                setState(() {
                  _setLength += 1;
                });
                setState(() {
                  _focusedIndex = _setLength + 1;
                });
                _mixpanel.track(
                  'Record Screen Putter Count Changed',
                  properties: {'Set Length': _setLength},
                );
                Future.delayed(const Duration(milliseconds: 25), () {
                  puttsMadePickerKey.currentState?.focusToItem(_setLength + 1);
                });
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.transparent, shadowColor: Colors.transparent),
            ),
          ],
        ),
      ],
    );
  }

  void dialogCallBack() {
    if (!sessionInProgress) {
      Navigator.pop(context);
    }
  }
}
